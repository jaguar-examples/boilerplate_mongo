import 'dart:async';

import 'package:angular2/core.dart';
import 'package:boilerplate_mongo/model/model.dart';
import 'package:http/browser_client.dart';
import 'package:teja_http_json/teja_http_json.dart';

final BrowserClient client = new BrowserClient();
final JsonClient jsonClient = new JsonClient(client);

@Injectable()
class TodoListService {
  Future<List<TodoItem>> getTodoList() async {
    final JsonResponse resp = await jsonClient.get('/api/todos');
    return todoItemSerializer.deserialize(resp.body);
  }

  Future<List<TodoItem>> add(String todo) async {
    if (todo is! String || todo.isEmpty) {
      throw new Exception('Invalid item!');
    }

    final JsonResponse resp =
        await jsonClient.post('/api/todos', body: {'title': todo});
    return todoItemSerializer.deserialize(resp.body);
  }

  Future<List<TodoItem>> removeById(String id) async {
    if (id is! String || id.isEmpty) {
      throw new Exception('Invalid Id!');
    }

    final JsonResponse resp = await jsonClient.delete('/api/todos/$id');
    return todoItemSerializer.deserialize(resp.body);
  }

  Future<TodoItem> setFinished(String id) async {
    if (id is! String || id.isEmpty) {
      throw new Exception('Invalid Id!');
    }

    final JsonResponse resp = await jsonClient.put('/api/todos/$id/finished');
    return todoItemSerializer.fromMap(resp.body);
  }

  Future<TodoItem> setUnfinished(String id) async {
    if (id is! String || id.isEmpty) {
      throw new Exception('Invalid Id!');
    }

    final JsonResponse resp = await jsonClient.put('/api/todos/$id/unfinished');
    return todoItemSerializer.fromMap(resp.body);
  }
}
