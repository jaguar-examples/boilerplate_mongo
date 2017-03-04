import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_mongo/api.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

main() async {
  Jaguar server = new Jaguar();
  server.addApi(reflectJaguar(new TodoApi()));
  await server.serve();
}