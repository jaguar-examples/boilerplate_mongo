// GENERATED CODE - DO NOT MODIFY BY HAND

part of model;

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$TodoItemSerializer implements Serializer<TodoItem> {
  @override
  Map<String, dynamic> toMap(TodoItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  TodoItem fromMap(Map map) {
    if (map == null) return null;
    final obj = new TodoItem();
    obj.id = map['id'] as String;
    obj.title = map['title'] as String;
    return obj;
  }
}

abstract class _$TodoItemMongoSerializer implements Serializer<TodoItem> {
  final _mongoId = const MongoId();
  @override
  Map<String, dynamic> toMap(TodoItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, '_id', _mongoId.serialize(model.id));
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  TodoItem fromMap(Map map) {
    if (map == null) return null;
    final obj = new TodoItem();
    obj.id = _mongoId.deserialize(map['_id'] as ObjectId);
    obj.title = map['title'] as String;
    return obj;
  }
}
