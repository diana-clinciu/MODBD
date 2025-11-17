import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

enum HttpMethod { get, post, put, delete }

typedef JSON = Map<String, dynamic>;

class HttpHeader {
  final String key;
  final String value;

  HttpHeader({required this.key, required this.value});
}

class URL {
  final String path;

  URL({required this.path});
  URL.fromUri(Uri uri) : path = uri.toString();
}

typedef Arguments = Map<String, dynamic>;
typedef APIClientDeserializer<T> = T Function(Map<String, dynamic>);

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final HttpClientResponse? response;
  final Map<String, dynamic>? errorBody; // Added this

  ApiException(
    this.message, {
    this.statusCode,
    this.response,
    this.errorBody, // Added this
  });

  @override
  String toString() =>
      'ApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class MultipartFormData {
  final List<_MultipartField> _fields = [];
  final String _boundary = _generateBoundary();

  static String _generateBoundary() {
    // Generate a proper boundary without leading dashes
    return 'WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}${DateTime.now().microsecondsSinceEpoch % 1000}';
  }

  /// Append a string field to the multipart form
  void append(String value, {required String withName}) {
    _fields.add(_MultipartField(
      name: withName,
      value: utf8.encode(value),
      isFile: false,
    ));
  }

  /// Append a file to the multipart form
  void appendFile(
    List<int> fileData, {
    required String withName,
    String? fileName,
    String? mimeType,
  }) {
    _fields.add(_MultipartField(
      name: withName,
      value: fileData,
      fileName: fileName,
      mimeType: mimeType ?? 'application/octet-stream', // Default MIME type
      isFile: true,
    ));
  }

  List<int> encode() {
    final List<int> body = [];

    for (final field in _fields) {
      // Start boundary
      body.addAll(utf8.encode('--$_boundary\r\n'));

      // Content-Disposition header
      body.addAll(
          utf8.encode('Content-Disposition: form-data; name="${field.name}"'));

      if (field.isFile && field.fileName != null) {
        body.addAll(utf8.encode('; filename="${field.fileName}"'));
      }
      body.addAll(utf8.encode('\r\n'));

      // Content-Type header (for files)
      if (field.isFile && field.mimeType != null) {
        body.addAll(utf8.encode('Content-Type: ${field.mimeType}\r\n'));
      }

      // Blank line before content
      body.addAll(utf8.encode('\r\n'));

      // Field value/file data
      body.addAll(field.value);

      // End with CRLF
      body.addAll(utf8.encode('\r\n'));
    }

    // Final boundary
    body.addAll(utf8.encode('--$_boundary--\r\n'));

    return body;
  }

  String get boundary => _boundary;

  // Helper to debug the multipart structure
  String preview() {
    final body = encode();
    return utf8.decode(body, allowMalformed: true);
  }
}

class _MultipartField {
  final String name;
  final List<int> value;
  final String? fileName;
  final String? mimeType;
  final bool isFile;

  _MultipartField({
    required this.name,
    required this.value,
    this.fileName,
    this.mimeType,
    required this.isFile,
  });
}

typedef MultipartEncoder = void Function(MultipartFormData form);

class ClientApi {
  final String baseURL;
  final HttpClient _httpClient;

  ClientApi({required this.baseURL}) : _httpClient = HttpClient();

  URL _buildEndpointURL(
      {required String path, Map<String, dynamic>? queryParameters}) {
    final baseUri = Uri.parse(baseURL);

    // Properly combine base URL with path
    String combinedPath;
    if ((path.startsWith('/') && !baseUri.path.endsWith('/')) ||
        (!path.startsWith('/') && baseUri.path.endsWith('/'))) {
      // If path starts with /, append it to the base path
      combinedPath = baseUri.path + path.trimRight();
    } else if (path.startsWith('/') && baseUri.path.endsWith('/')) {
      // If both have /, avoid double slashes
      combinedPath = baseUri.path + path.substring(1).trimRight();
    } else {
      // If path doesn't start with /, add a separator
      combinedPath = "${baseUri.path}/${path}";
    }

    final uri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: combinedPath,
        queryParameters: queryParameters);

    debugPrint("Endpoint path: ${uri.toString()}");
    return URL.fromUri(uri);
  }

  Future<T> callFuture<T>(
      {required HttpMethod method,
      required URL endpoint,
      Arguments? query,
      Arguments? parameters,
      List<HttpHeader>? headers,
      Function(HttpClientResponse?)? errorProcessor,
      required APIClientDeserializer<T> deserializer}) async {
    HttpClientRequest? request;
    HttpClientResponse? response;

    try {
      final uri = Uri.parse(endpoint.path);

      switch (method) {
        case HttpMethod.get:
          request = await _httpClient.getUrl(uri);
          break;
        case HttpMethod.post:
          request = await _httpClient.postUrl(uri);
          break;
        case HttpMethod.put:
          request = await _httpClient.putUrl(uri);
          break;
        case HttpMethod.delete:
          request = await _httpClient.deleteUrl(uri);
          break;
      }

      if (headers != null) {
        for (final header in headers) {
          request.headers.add(header.key, header.value);
        }
      }

      request.headers.contentType =
          ContentType('application', 'json', charset: 'utf-8');

      if (parameters != null) {
        final jsonBody = jsonEncode(parameters);
        request.write(jsonBody);
      }

      response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = json.decode(responseBody) as Map<String, dynamic>;
        } catch (e) {
          // Not JSON, keep as null
        }

        if (errorProcessor != null) {
          errorProcessor(response);
        }
        throw ApiException(
          'HTTP Error: ${response.statusCode} ${response.reasonPhrase}',
          statusCode: response.statusCode,
          response: response,
          errorBody: errorBody,
        );
      }

      final Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        throw ApiException('Failed to parse JSON response: $e');
      }

      return deserializer(jsonResponse);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      if (errorProcessor != null) {
        errorProcessor(response);
      }

      throw ApiException('Request failed: $e');
    }
  }

  Future<T> get<T>(
      {required String path,
      Arguments? query,
      List<HttpHeader>? headers,
      Function(HttpClientResponse?)? errorProcessor,
      required APIClientDeserializer<T> deserializer}) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    return callFuture<T>(
        method: HttpMethod.get,
        endpoint: url,
        headers: headers,
        errorProcessor: errorProcessor,
        deserializer: deserializer);
  }

  Future<T> post<T>(
      {required String path,
      Arguments? query,
      Arguments? parameters,
      List<HttpHeader>? headers,
      Function(HttpClientResponse?)? errorProcessor,
      required APIClientDeserializer<T> deserializer}) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    return callFuture<T>(
        method: HttpMethod.post,
        endpoint: url,
        parameters: parameters,
        headers: headers,
        errorProcessor: errorProcessor,
        deserializer: deserializer);
  }

  Future<T> put<T>(
      {required String path,
      Arguments? query,
      Arguments? parameters,
      List<HttpHeader>? headers,
      Function(HttpClientResponse?)? errorProcessor,
      required APIClientDeserializer<T> deserializer}) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    return callFuture<T>(
        method: HttpMethod.put,
        endpoint: url,
        parameters: parameters,
        headers: headers,
        errorProcessor: errorProcessor,
        deserializer: deserializer);
  }

  Future<T> delete<T>(
      {required String path,
      Arguments? query,
      List<HttpHeader>? headers,
      Function(HttpClientResponse?)? errorProcessor,
      required APIClientDeserializer<T> deserializer}) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    return callFuture<T>(
        method: HttpMethod.delete,
        endpoint: url,
        headers: headers,
        errorProcessor: errorProcessor,
        deserializer: deserializer);
  }

  Future<T> multiPartRequest<T>({
    required String path,
    Arguments? query,
    required MultipartEncoder multipartEncoding,
    List<HttpHeader>? headers,
    Function(HttpClientResponse?)? errorProcessor,
    required APIClientDeserializer<T> deserializer,
  }) async {
    HttpClientRequest? request;
    HttpClientResponse? response;

    try {
      final url = _buildEndpointURL(path: path, queryParameters: query);
      final uri = Uri.parse(url.path);

      request = await _httpClient.postUrl(uri);

      // Create multipart form data
      final form = MultipartFormData();
      multipartEncoding(form);

      // Set content type with boundary
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=${form.boundary}',
      );

      // Add custom headers
      if (headers != null) {
        for (final header in headers) {
          request.headers.add(header.key, header.value);
        }
      }

      // Write multipart body
      final body = form.encode();
      request.contentLength = body.length;
      request.add(body);

      response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Try to parse error body as JSON
        Map<String, dynamic>? errorBody;
        try {
          errorBody = json.decode(responseBody) as Map<String, dynamic>;
        } catch (e) {
          // Not JSON, keep as null
        }

        if (errorProcessor != null) {
          errorProcessor(response);
        }

        throw ApiException(
          'HTTP Error: ${response.statusCode} ${response.reasonPhrase}\nBody: $responseBody',
          statusCode: response.statusCode,
          response: response,
          errorBody: errorBody, // Include parsed error body
        );
      }

      final Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
      } catch (e) {
        throw ApiException(
          'Failed to parse JSON response: $e',
        );
      }

      return deserializer(jsonResponse);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      if (errorProcessor != null) {
        errorProcessor(response);
      }

      throw ApiException('Request failed: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
