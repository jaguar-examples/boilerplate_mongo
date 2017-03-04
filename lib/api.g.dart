// GENERATED CODE - DO NOT MODIFY BY HAND

part of boilerplate_mongo.api;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TodoItemMongoSerializer
// **************************************************************************

abstract class _$TodoItemMongoSerializer implements Serializer<TodoItem> {
  Map toMap(TodoItem model, {bool withTypeInfo: false, String typeInfoKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["_id"] = new MongoId(#id).to(model.id);
      }
      if (model.title != null) {
        ret["title"] = model.title;
      }
      if (model.message != null) {
        ret["message"] = model.message;
      }
    }
    return ret;
  }

  TodoItem fromMap(Map map, {TodoItem model, String typeInfoKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! TodoItem) {
      model = createModel();
    }
    model.id = new MongoId(#id).from(map["_id"]);
    model.title = map["title"];
    model.message = map["message"];
    return model;
  }

  String modelString() => "TodoItem";
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class TodoItemSerializer
// **************************************************************************

abstract class _$TodoItemSerializer implements Serializer<TodoItem> {
  Map toMap(TodoItem model, {bool withTypeInfo: false, String typeInfoKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.title != null) {
        ret["title"] = model.title;
      }
      if (model.message != null) {
        ret["message"] = model.message;
      }
    }
    return ret;
  }

  TodoItem fromMap(Map map, {TodoItem model, String typeInfoKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! TodoItem) {
      model = createModel();
    }
    model.id = map["id"];
    model.title = map["title"];
    model.message = map["message"];
    return model;
  }

  String modelString() => "TodoItem";
}
