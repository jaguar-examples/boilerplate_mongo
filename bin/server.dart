import 'package:jaguar/jaguar.dart';
import 'package:boilerplate_mongo/api.dart';
import 'package:jaguar_dev_proxy/jaguar_dev_proxy.dart';

main() async {
  // Proxy all html client requests to pub server
  final proxy = new PrefixedProxyServer('/', 'http://localhost:8082/');

  Jaguar server = new Jaguar();
  server.addApiReflected(new TodoApi());
  server.addApi(proxy);
  await server.serve();
}
