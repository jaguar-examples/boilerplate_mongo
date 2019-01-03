// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_mongo.api;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

import 'package:boilerplate_mongo/model/model.dart';

export 'package:boilerplate_mongo/model/model.dart';

const todoColl = "todo";

final mgoPool = MongoPool("mongodb://localhost:27018/todos");

@GenController(path: '/api/todos')
class TodoApi extends Controller {
  @GetJson()
  Future<List<TodoItem>> getAll(Context ctx) async {
    final db = await mgoPool(ctx);
    final coll = db.collection(todoColl);
    return await coll.find().map(mongoSerializer.fromMap).toList();
  }

  @PostJson()
  Future<List<TodoItem>> insert(Context ctx) async {
    String title = await ctx.bodyAsText();
    TodoItem todo = TodoItem(title: title);
    final String id = mgo.ObjectId().toHexString();
    todo.id = id;

    final db = await mgoPool(ctx);
    final coll = db.collection(todoColl);
    await coll.insert(mongoSerializer.toMap(todo));

    return coll.find().map(mongoSerializer.fromMap).toList();
  }

  @DeleteJson(path: '/:id')
  Future<List<TodoItem>> deleteById(Context ctx) async {
    String id = ctx.pathParams['id'];
    final db = await mgoPool(ctx);
    final coll = db.collection(todoColl);
    await coll.remove(mgo.where.id(mgo.ObjectId.parse(id)));

    return coll.find().map(mongoSerializer.fromMap).toList();
  }
}
