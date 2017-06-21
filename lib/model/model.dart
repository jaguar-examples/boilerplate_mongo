library model;

import 'package:jaguar_serializer/serializer.dart';

part 'model.g.dart';

class TodoItem {
  String id;

  String title;

  bool finished;

  void clone(final TodoItem other) {
    id = other.id;
    title = other.title;
    finished = other.finished;
  }
}

@GenSerializer()
class TodoItemSerializer extends Serializer<TodoItem>
    with _$TodoItemSerializer {
  TodoItem createModel() => new TodoItem();
}

final TodoItemSerializer todoItemSerializer = new TodoItemSerializer();