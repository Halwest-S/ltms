List<Map<String, dynamic>> extractMapList(
  dynamic body, {
  String key = 'data',
}) {
  final dynamic source =
      body is List
          ? body
          : body is Map
          ? body[key] ?? body['items'] ?? body['results']
          : null;

  if (source is! Iterable) {
    throw FormatException(
      'Expected iterable response body but got ${source.runtimeType}',
    );
  }

  return source
      .map<Map<String, dynamic>>((item) {
        if (item is! Map) {
          throw FormatException(
            'Expected map item in iterable but got ${item.runtimeType}',
          );
        }
        return Map<String, dynamic>.from(item);
      })
      .toList();
}

Map<String, dynamic> extractMapBody(
  dynamic body, {
  String key = 'data',
}) {
  final dynamic source =
      body is Map && body[key] is Map ? body[key] : body;

  if (source is! Map) {
    throw FormatException(
      'Expected map response body but got ${source.runtimeType}',
    );
  }

  return Map<String, dynamic>.from(source);
}
