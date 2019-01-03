library model;

import 'package:mongo_dart/mongo_dart.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';

part 'model.jser.dart';

class TodoItem {
  String id;

  String title;

  TodoItem({this.id, this.title});

  Map<String, dynamic> toJson() => jsonSerializer.toMap(this);
}

@GenSerializer()
class TodoItemSerializer extends Serializer<TodoItem>
    with _$TodoItemSerializer {
}

final TodoItemSerializer todoItemSerializer = new TodoItemSerializer();


@GenSerializer(fields: {"id": EnDecode(alias: "_id", processor: MongoId())})
class TodoItemMongoSerializer extends Serializer<TodoItem>
    with _$TodoItemMongoSerializer {
}

final jsonSerializer = TodoItemSerializer();

final mongoSerializer = TodoItemMongoSerializer();