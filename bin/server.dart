import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Static file handler
  final staticHandler = createStaticHandler(
    'build/web',
    defaultDocument: 'index.html',
  );

  // SPA fallback: redirect missing routes back to index.html
  final handler = Pipeline().addHandler((request) async {
    final response = await staticHandler(request);
    if (response.statusCode == 404 && !request.url.path.contains('.')) {
      final indexFile = File('build/web/index.html');
      if (await indexFile.exists()) {
        return Response.ok(
          await indexFile.readAsBytes(),
          headers: {'content-type': 'text/html'},
        );
      }
    }
    return response;
  });

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Serving Flutter Web at http://localhost:${server.port}');
}
