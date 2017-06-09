import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

const String kHostname = 'localhost';

const int kPort = 8080;

final http.Client _client = new http.Client();

Future<Null> printHttpClientResponse(http.Response resp) async {
  print('=========================');
  print("body:");
  print(resp.body);
  print("statusCode:");
  print(resp.statusCode);
  print("headers:");
  print(resp.headers);
  print('=========================');
}

Future<Null> deleteAll() async {
  String url = "http://$kHostname:$kPort/api/todos";
  http.Response resp = await _client.delete(url);

  await printHttpClientResponse(resp);
}

Future<Map> insert(Map map) async {
  String url = "http://$kHostname:$kPort/api/todos";
  http.Response resp = await _client.post(url, body: JSON.encode(map));

  await printHttpClientResponse(resp);

  return JSON.decode(resp.body);
}

Future<Null> getAll() async {
  String url = "http://$kHostname:$kPort/api/todos";
  http.Response resp = await _client.get(url);

  await printHttpClientResponse(resp);
}

Future<Null> getById(String id) async {
  String url = "http://$kHostname:$kPort/api/todos/$id";
  http.Response resp = await _client.get(url);

  await printHttpClientResponse(resp);
}

Future<Map> update(Map map) async {
  String url = "http://$kHostname:$kPort/api/todos";
  http.Response resp = await _client.put(url, body: JSON.encode(map));

  await printHttpClientResponse(resp);

  return JSON.decode(resp.body);
}

Future<Null> setFinished(String id) async {
  String url = "http://$kHostname:$kPort/api/todos/$id/finished";
  http.Response resp = await _client.put(url);

  await printHttpClientResponse(resp);
}

Future<Null> setUnfinished(String id) async {
  String url = "http://$kHostname:$kPort/api/todos/$id/unfinished";
  http.Response resp = await _client.put(url);

  await printHttpClientResponse(resp);
}

Future<Null> deleteById(String id) async {
  String url = "http://$kHostname:$kPort/api/todos/$id";
  http.Response resp = await _client.delete(url);

  await printHttpClientResponse(resp);
}

main() async {
  print('Deleting all:');
  await deleteAll();
  print('Inserting new:');
  Map data = await insert({"title": "Title 1", "message": "Message 1", "finished": false});
  print('Get all:');
  await getAll();
  print('Getting by id ${data['id']}:');
  await getById(data['id']);
  print('Updating:');
  data['title'] = "New title";
  data['message'] = "New message";
  await update(data);
  print('Get all:');
  await getAll();
  print('Setting finished:');
  await setFinished(data['id']);
  await getById(data['id']);
  print('Setting unfinished');
  await setUnfinished(data['id']);
  await getById(data['id']);
  print('Deleting by id ${data['id']}');
  await deleteById(data['id']);
  print('Get all:');
  await getAll();
  exit(0);
}