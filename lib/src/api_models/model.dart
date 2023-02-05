typedef Json = Map<String, dynamic>;

abstract class RequestModel {
  Json toJson();
}

typedef FromJson<T> = T Function(Json json);
