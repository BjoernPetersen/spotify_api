abstract class RequestModel {
  Map<String, dynamic> toJson();
}

typedef FromJson<T> = T Function(Map<String, dynamic> json);
