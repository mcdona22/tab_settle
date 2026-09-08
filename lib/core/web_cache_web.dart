import 'dart:js_interop';

import 'package:web/web.dart' as web;

void killServiceWorkers() {
  final serviceWorker = web.window.navigator.serviceWorker;

  serviceWorker.getRegistrations().toDart.then((JSAny registrations) {
    final list = (registrations as JSArray).toDart;
    for (final reg in list) {
      (reg as web.ServiceWorkerRegistration).unregister();
    }
  });
}
