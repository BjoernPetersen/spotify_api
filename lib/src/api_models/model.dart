typedef Json = Map<String, dynamic>;

abstract class RequestModel {
  Json toJson();
}

typedef FromJson<T> = T Function(Json json);

int parseNumAsInt(num val) {
  return val.round();
}

int? parseOptionalNumAsInt(num? val) {
  return val?.round();
}
