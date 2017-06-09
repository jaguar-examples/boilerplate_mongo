// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_mongo.api;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_serializer/serializer.dart';
import 'package:jaguar_serializer_mongo/jaguar_serializer_mongo.dart';
import 'package:jaguar_mongo/jaguar_mongo.dart';

part 'api.g.dart';

const mongoUrl = "mongodb://localhost:27018/todos";
const todoColl = "todo";

class TodoItem {
  String id;

  String title;

  String message;

  bool finished;
}

@GenSerializer()
@MongoId(#id)
@EnDecodeField(#id, asAndFrom: '_id')
class TodoItemMongoSerializer extends Serializer<TodoItem>
    with _$TodoItemMongoSerializer {
  TodoItem createModel() => new TodoItem();
}

@GenSerializer()
class TodoItemSerializer extends Serializer<TodoItem>
    with _$TodoItemSerializer {
  TodoItem createModel() => new TodoItem();
}

final TodoItemSerializer jsonSerializer = new TodoItemSerializer();

final TodoItemMongoSerializer mongoSerializer = new TodoItemMongoSerializer();

@Api(path: '/api/todos')
@Wrap(const [#mongoDb])
class TodoApi {
  MongoDb mongoDb(Context ctx) => new MongoDb(mongoUrl);

  @Get()
  Future<Response<String>> getAll(Context ctx) async {
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    List<Map> res = await (await coll.find()).map(_mgoToJson).toList();
    return Response.json(res);
  }

  @Get(path: '/:id')
  Future<Response<String>> getById(Context ctx) async {
    String id = ctx.pathParams['id'];
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return Response.json(_mgoToJson(res));
  }

  @Post()
  Future<Response<String>> insert(Context ctx) async {
    Map body = await ctx.req.bodyAsJsonMap();
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    TodoItem todo = jsonSerializer.fromMap(body);
    final String id = new mgo.ObjectId().toHexString();
    todo.id = id;
    final coll = db.collection(todoColl);
    await coll.insert(mongoSerializer.toMap(todo));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return Response.json(_mgoToJson(res));
  }

  @Put()
  Future<Response<String>> update(Context ctx) async {
    Map body = await ctx.req.bodyAsJsonMap();
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    TodoItem todo = jsonSerializer.fromMap(body);
    final String id = todo.id;
    final coll = db.collection(todoColl);
    await coll.update(mgo.where.id(mgo.ObjectId.parse(id)), _mgoEnc(todo));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return Response.json(_mgoToJson(res));
  }

  @Put(path: '/:id/finished')
  Future<Response<String>> updateFinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    await coll.update(
        mgo.where.id(mgo.ObjectId.parse(id)), mgo.modify.set('finished', true));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return Response.json(_mgoToJson(res));
  }

  @Put(path: '/:id/unfinished')
  Future<Response<String>> updateUnfinished(Context ctx) async {
    String id = ctx.pathParams['id'];
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    await coll.update(mgo.where.id(mgo.ObjectId.parse(id)),
        mgo.modify.set('finished', false));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return Response.json(_mgoToJson(res));
  }

  @Delete(path: '/:id')
  Future deleteById(Context ctx) async {
    String id = ctx.pathParams['id'];
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    await coll.remove(mgo.where.id(mgo.ObjectId.parse(id)));
  }

  @Delete()
  Future deleteAll(Context ctx) async {
    mgo.Db db = ctx.getInput<mgo.Db>(MongoDb);
    final coll = db.collection(todoColl);
    await coll.remove();
  }

  Map _mgoEnc(TodoItem item) => mongoSerializer.toMap(item);

  Map _mgoToJson(Map map) => jsonSerializer.toMap(mongoSerializer.fromMap(map));
}
