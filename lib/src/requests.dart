import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:spotify_api/src/api_models/model.dart';

enum ContentType {
  json('application/json'),
  ;

  final String value;

  const ContentType(this.value);
}

@immutable
final class Header {
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
      name: 'Authorization',
      value: 'Basic $encoded',
    );
  }

  Header.bearerAuth(
    String token,
  ) : this(
          name: 'Authorization',
          value: 'Bearer $token',
        );

  Header.contentType(
    ContentType type,
  ) : this(
          name: 'Content-Type',
          value: type.value,
        );
}

@immutable
final class Response {
  final http.Response _response;

  Response(this._response);

  int get statusCode => _response.statusCode;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  String? header(String headerName) => _response.headers[headerName];

  ResponseBody get body => ResponseBody(_response.bodyBytes);
}

@immutable
final class RequestBody {
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
final class ResponseBody {
  final List<int> rawBytes;

  ResponseBody(this.rawBytes);

  String asString([Encoding encoding = utf8]) => encoding.decode(rawBytes);

  dynamic _decode() {
    return jsonDecode(utf8.decode(rawBytes));
  }

  List<T> decodeJsonPrimitiveList<T>() {
    final decoded = _decode() as List;
    return decoded.cast();
  }

  List<T> decodeJsonList<T>(FromJson<T> itemFromJson) {
    final List decoded = _decode();
    return decoded.map((e) => itemFromJson(e)).toList(growable: false);
  }

  T decodeJson<T>(FromJson<T> fromJson) {
    return fromJson(_decode());
  }
}

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
    required RequestBody? body,
    List<Header> headers = const [],
    Map<String, String> params = const {},
  }) async {
    final urlWithParams = url.includeParams(params);
    final rawResponse = await _client.delete(
      urlWithParams,
      headers: {
        for (final header in headers) header.name: header.value,
      },
      body: body?.body,
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
