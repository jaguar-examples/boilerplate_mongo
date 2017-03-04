// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library boilerplate_mongo.api;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart' as mgo;
import 'package:jaguar/jaguar.dart';
import 'package:jaguar/interceptors.dart';
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
@WrapMongoDb(mongoUrl)
@WrapEncodeToJson()
class TodoApi {
  @Get()
  Future<List<Map>> getAll(@Input(MongoDb) mgo.Db db) async {
    final coll = db.collection(todoColl);
    return await (await coll.find()).map(_mgoToJson).toList();
  }

  @Get(path: '/:id')
  Future<Map> getById(@Input(MongoDb) mgo.Db db, String id) async {
    final coll = db.collection(todoColl);
    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return _mgoToJson(res);
  }

  @Post()
  @WrapDecodeJsonMap()
  Future<Map> insert(
      @Input(MongoDb) mgo.Db db, @Input(DecodeJsonMap) Map body) async {
    TodoItem todo = jsonSerializer.fromMap(body);
    final String id = new mgo.ObjectId().toHexString();
    todo.id = id;
    final coll = db.collection(todoColl);
    await coll.insert(mongoSerializer.toMap(todo));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return _mgoToJson(res);
  }

  @Put()
  @WrapDecodeJsonMap()
  Future<Map> update(
      @Input(MongoDb) mgo.Db db, @Input(DecodeJsonMap) Map body) async {
    TodoItem todo = jsonSerializer.fromMap(body);
    final String id = todo.id;
    final coll = db.collection(todoColl);
    await coll.update(mgo.where.id(mgo.ObjectId.parse(id)), _mgoEnc(todo));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return _mgoToJson(res);
  }

  @Put(path: '/:id/finished')
  @WrapDecodeJsonMap()
  Future<Map> updateFinished(@Input(MongoDb) mgo.Db db, String id) async {
    final coll = db.collection(todoColl);
    await coll.update(
        mgo.where.id(mgo.ObjectId.parse(id)), mgo.modify.set('finished', true));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return _mgoToJson(res);
  }

  @Put(path: '/:id/unfinished')
  @WrapDecodeJsonMap()
  Future<Map> updateUnfinished(@Input(MongoDb) mgo.Db db, String id) async {
    final coll = db.collection(todoColl);
    await coll.update(
        mgo.where.id(mgo.ObjectId.parse(id)), mgo.modify.set('finished', false));

    Map res = await coll.findOne(mgo.where.id(mgo.ObjectId.parse(id)));
    return _mgoToJson(res);
  }

  @Delete(path: '/:id')
  Future deleteById(@Input(MongoDb) mgo.Db db, String id) async {
    final coll = db.collection(todoColl);
    await coll.remove(mgo.where.id(mgo.ObjectId.parse(id)));
  }

  @Delete()
  Future deleteAll(@Input(MongoDb) mgo.Db db) async {
    final coll = db.collection(todoColl);
    await coll.remove();
  }

  Map _mgoEnc(TodoItem item) => mongoSerializer.toMap(item);

  Map _mgoToJson(Map map) => jsonSerializer.toMap(mongoSerializer.fromMap(map));
}
