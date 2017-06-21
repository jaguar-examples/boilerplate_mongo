// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:boilerplate_mongo/model/model.dart';

import 'todo_list_service.dart';

@Component(
  selector: 'todo-list',
  styleUrls: const ['todo_list_component.css'],
  templateUrl: 'todo_list_component.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [TodoListService],
)
class TodoListComponent implements OnInit {
  final TodoListService service;

  List<TodoItem> items = [];

  String newTodo = '';

  TodoListComponent(this.service);

  @override
  Future<Null> ngOnInit() async {
    items = await service.getTodoList();
  }

  add() async {
    items = await service.add(newTodo);
    newTodo = '';
  }

  Future<Null> remove(TodoItem item) async {
    items = await service.removeById(item.id);
  }

  Future<Null> updateFinished(TodoItem item, bool finished) async {
    if(finished) {
      item.clone(await service.setFinished(item.id));
    } else {
      item.clone(await service.setUnfinished(item.id));
    }
  }
}
