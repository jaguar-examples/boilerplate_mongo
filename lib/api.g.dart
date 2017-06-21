// GENERATED CODE - DO NOT MODIFY BY HAND

part of boilerplate_mongo.api;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TodoItemMongoSerializer
// **************************************************************************

abstract class _$TodoItemMongoSerializer implements Serializer<TodoItem> {
  final MongoId idMongoId = const MongoId(#id);

  Map toMap(TodoItem model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["_id"] = idMongoId.serialize(model.id);
      }
      if (model.title != null) {
        ret["title"] = model.title;
      }
      if (model.finished != null) {
        ret["finished"] = model.finished;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  TodoItem fromMap(Map map, {TodoItem model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! TodoItem) {
      model = createModel();
    }
    model.id = idMongoId.deserialize(map["_id"]);
    model.title = map["title"];
    model.finished = map["finished"];
    return model;
  }

  String modelString() => "TodoItem";
}
