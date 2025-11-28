import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
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
typedef APIClientDeserializer<T> = T Function(dynamic json);

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorBody; // Added this

  ApiException(
    this.message, {
    this.statusCode,
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
  final http.Client _httpClient;

  ClientApi({required this.baseURL}) : _httpClient = http.Client();

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

  Future<T> callFuture<T>({
    required HttpMethod method,
    required URL endpoint,
    Arguments? parameters,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) async {
    try {
      final uri = Uri.parse(endpoint.path);

      // Construim headers
      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null)
          for (var h in headers) h.key: h.value,
      };

      late http.Response response;

      // Trimitem requestul
      switch (method) {
        case HttpMethod.get:
          response = await _httpClient.get(uri, headers: requestHeaders);
          break;
        case HttpMethod.post:
          response = await _httpClient.post(
            uri,
            headers: requestHeaders,
            body: parameters != null ? jsonEncode(parameters) : null,
          );
          break;
        case HttpMethod.put:
          response = await _httpClient.put(
            uri,
            headers: requestHeaders,
            body: parameters != null ? jsonEncode(parameters) : null,
          );
          break;
        case HttpMethod.delete:
          response = await _httpClient.delete(
            uri,
            headers: requestHeaders,
          );
          break;
      }

      // Verificăm codul de status
      if (response.statusCode < 200 || response.statusCode >= 300) {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        throw ApiException(
          'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
          errorBody: errorBody,
        );
      }

      final dynamic jsonResponse = jsonDecode(response.body);
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<T> get<T>({
    required String path,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) {
    final url = _buildEndpointURL(path: path);
    return callFuture<T>(
        method: HttpMethod.get,
        endpoint: url,
        headers: headers,
        deserializer: deserializer);
  }

  Future<T> post<T>({
    required String path,
    Arguments? parameters,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) {
    final url = _buildEndpointURL(path: path);
    return callFuture<T>(
        method: HttpMethod.post,
        endpoint: url,
        parameters: parameters,
        headers: headers,
        deserializer: deserializer);
  }

  Future<T> put<T>({
    required String path,
    Arguments? query,
    Arguments? parameters,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    try {
      final uri = Uri.parse(url.path);

      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null)
          for (var h in headers) h.key: h.value,
      };

      final response = await http.put(
        uri,
        headers: requestHeaders,
        body: parameters != null ? jsonEncode(parameters) : null,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        throw ApiException(
          'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
          errorBody: errorBody,
        );
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<T> delete<T>({
    required String path,
    Arguments? query,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    try {
      final uri = Uri.parse(url.path);

      final Map<String, String> requestHeaders = {
        if (headers != null)
          for (var h in headers) h.key: h.value,
      };

      final response = await http.delete(uri, headers: requestHeaders);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        throw ApiException(
          'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
          errorBody: errorBody,
        );
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Request failed: $e');
    }
  }

  Future<T> multiPartRequest<T>({
    required String path,
    Arguments? query,
    required MultipartEncoder multipartEncoding,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) async {
    final url = _buildEndpointURL(path: path, queryParameters: query);
    try {
      final uri = Uri.parse(url.path);

      final request = http.MultipartRequest('POST', uri);

      // Adăugăm headers
      if (headers != null) {
        for (var h in headers) {
          request.headers[h.key] = h.value;
        }
      }

      // Construim multipart data
      final form = MultipartFormData();
      multipartEncoding(form);

      for (var field in form._fields) {
        if (field.isFile && field.fileName != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              field.name,
              field.value,
              filename: field.fileName!,
              contentType: field.mimeType != null
                  ? MediaType.parse(field.mimeType!)
                  : null,
            ),
          );
        } else {
          request.fields[field.name] = utf8.decode(field.value);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {}
        throw ApiException(
          'HTTP Error: ${response.statusCode}',
          statusCode: response.statusCode,
          errorBody: errorBody,
        );
      }

      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Multipart request failed: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
