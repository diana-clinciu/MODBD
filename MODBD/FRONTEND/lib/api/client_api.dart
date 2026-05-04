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
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errorBody;

  ApiException(
    this.message, {
    this.statusCode,
    this.errorBody,
  });

  @override
  String toString() =>
      'ApiException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}

class MultipartFormData {
  final List<_MultipartField> _fields = [];
  final String _boundary = _generateBoundary();

  static String _generateBoundary() {
    return 'WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}${DateTime.now().microsecondsSinceEpoch % 1000}';
  }

  void append(String? value, {required String withName}) {
    _fields.add(_MultipartField(
      name: withName,
      value: utf8.encode(value ?? ''),
      isFile: false,
    ));
  }

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
      mimeType: mimeType ?? 'application/octet-stream',
      isFile: true,
    ));
  }

  List<int> encode() {
    final List<int> body = [];

    for (final field in _fields) {
      body.addAll(utf8.encode('--$_boundary\r\n'));
      body.addAll(
          utf8.encode('Content-Disposition: form-data; name="${field.name}"'));

      if (field.isFile && field.fileName != null) {
        body.addAll(utf8.encode('; filename="${field.fileName}"'));
      }
      body.addAll(utf8.encode('\r\n'));

      if (field.isFile && field.mimeType != null) {
        body.addAll(utf8.encode('Content-Type: ${field.mimeType}\r\n'));
      }

      body.addAll(utf8.encode('\r\n'));
      body.addAll(field.value);
      body.addAll(utf8.encode('\r\n'));
    }

    body.addAll(utf8.encode('--$_boundary--\r\n'));
    return body;
  }

  String get boundary => _boundary;

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

    String combinedPath;
    if ((path.startsWith('/') && !baseUri.path.endsWith('/')) ||
        (!path.startsWith('/') && baseUri.path.endsWith('/'))) {
      combinedPath = baseUri.path + path.trimRight();
    } else if (path.startsWith('/') && baseUri.path.endsWith('/')) {
      combinedPath = baseUri.path + path.substring(1).trimRight();
    } else {
      combinedPath = '${baseUri.path}/$path';
    }

    final uri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: combinedPath,
        queryParameters: queryParameters);

    debugPrint('Endpoint path: ${uri.toString()}');
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

      final Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        if (headers != null)
          for (var h in headers) h.key: h.value,
      };

      late http.Response response;

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

      final dynamic jsonResponse = jsonDecode(response.body);
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

      final dynamic jsonResponse = jsonDecode(response.body);
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

      if (headers != null) {
        for (var h in headers) {
          request.headers[h.key] = h.value;
        }
      }

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

      final dynamic jsonResponse = jsonDecode(response.body);
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Multipart request failed: $e');
    }
  }

  Future<T> sendForm<T>({
    required String method,
    required String path,
    required Map<String, String> fields,
    List<HttpHeader>? headers,
    required APIClientDeserializer<T> deserializer,
  }) async {
    final url = _buildEndpointURL(path: path);
    try {
      final uri = Uri.parse(url.path);
      final request = http.MultipartRequest(method, uri);
      if (headers != null) {
        for (var h in headers) {
          request.headers[h.key] = h.value;
        }
      }
      request.fields.addAll(fields);
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
      final dynamic jsonResponse = jsonDecode(response.body);
      return deserializer(jsonResponse);
    } catch (e) {
      throw ApiException('Form request failed: $e');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
