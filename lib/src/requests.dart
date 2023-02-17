import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

@immutable
class Header {
  final String name;
  final String value;

  const Header({
    required this.name,
    required this.value,
  });

  factory Header.basicAuth({
    required String username,
    required String password,
    Encoding encoding = utf8,
  }) {
    final bytes = encoding.encode('$username:$password');
    final encoded = base64.encode(bytes);
    return Header(
      name: HttpHeaders.authorizationHeader,
      value: 'Basic $encoded',
    );
  }

  Header.bearerAuth(
    String token,
  ) : this(
          name: HttpHeaders.authorizationHeader,
          value: 'Bearer $token',
        );

  Header.contentType(
    ContentType type,
  ) : this(
          name: HttpHeaders.contentTypeHeader,
          value: type.value,
        );
}

@immutable
class Response {
  final http.Response _response;

  Response(this._response);

  int get statusCode => _response.statusCode;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  ResponseBody get body => ResponseBody(_response.bodyBytes);
}

@immutable
class RequestBody {
  final Object body;
  final List<Header> headers;

  RequestBody._({
    required this.body,
    required this.headers,
  });

  RequestBody.formData(
    Map<String, String> data,
  ) : this._(
          body: data,
          headers: const [],
        );

  RequestBody.json(RequestModel model)
      : this._(
          body: JsonUtf8Encoder().convert(model.toJson()),
          headers: [Header.contentType(ContentType.json)],
        );
}

@immutable
class ResponseBody {
  final List<int> rawBytes;

  ResponseBody(this.rawBytes);

  String asString([Encoding encoding = utf8]) => encoding.decode(rawBytes);

  List<T> decodeJsonList<T>(FromJson<T> itemFromJson) {
    final List decoded = jsonDecode(
      utf8.decode(rawBytes),
    );
    return decoded
        .map((e) => itemFromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  T decodeJson<T>(FromJson<T> fromJson) {
    return fromJson(jsonDecode(utf8.decode(rawBytes)));
  }
}

class HttpException implements Exception {}

extension on Uri {
  Uri includeParams(Map<String, String> params) {
    final Map<String, String> newParams = Map.from(queryParameters);
    newParams.addAll(params);
    return replace(queryParameters: newParams);
  }
}

@immutable
class RequestsClient {
  final http.Client _client;

  RequestsClient() : _client = http.Client();

  Future<Response> get(
    Uri url, {
    List<Header> headers = const [],
    Map<String, String> params = const {},
  }) async {
    final urlWithParams = url.includeParams(params);
    final rawResponse = await _client.get(
      urlWithParams,
      headers: {
        for (final header in headers) header.name: header.value,
      },
    );

    return Response(rawResponse);
  }

  Future<Response> delete(
    Uri url, {
    List<Header> headers = const [],
    Map<String, String> params = const {},
  }) async {
    final urlWithParams = url.includeParams(params);
    final rawResponse = await _client.delete(
      urlWithParams,
      headers: {
        for (final header in headers) header.name: header.value,
      },
    );

    return Response(rawResponse);
  }

  Future<Response> post(
    Uri url, {
    required RequestBody? body,
    List<Header> headers = const [],
    Map<String, String> params = const {},
  }) async {
    final urlWithParams = url.includeParams(params);
    final rawResponse = await _client.post(
      urlWithParams,
      headers: {
        for (final header in headers) header.name: header.value,
        if (body != null)
          for (final header in body.headers) header.name: header.value,
      },
      body: body?.body,
    );

    return Response(rawResponse);
  }

  Future<Response> put(
    Uri url, {
    required RequestBody? body,
    List<Header> headers = const [],
    Map<String, String> params = const {},
  }) async {
    final urlWithParams = url.includeParams(params);
    final rawResponse = await _client.put(
      urlWithParams,
      headers: {
        for (final header in headers) header.name: header.value,
        if (body != null)
          for (final header in body.headers) header.name: header.value,
      },
      body: body?.body,
    );

    return Response(rawResponse);
  }

  void close() {
    _client.close();
  }
}
