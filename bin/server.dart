import 'package:boilerplate_mongo/api.dart';

main() async {
  final item = new TodoItem()
    ..id = "111111111111111111111111"
    ..title = "Item 1"
    ..message = "Message 1";

  final serializer = new TodoItemSerializer();
  final mongoSerializer = new TodoItemMongoSerializer();

  print(serializer.toMap(item));
  print(mongoSerializer.toMap(item));
}
