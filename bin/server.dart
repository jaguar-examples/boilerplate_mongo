import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_mongo/api.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

main() async {

  final server = Jaguar(port: 10000);
  server.add(reflect(TodoApi()));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);
}
