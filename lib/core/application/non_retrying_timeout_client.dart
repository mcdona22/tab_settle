import 'package:http/http.dart' as http;

class NonRetryingTimeoutClient extends http.BaseClient {
  NonRetryingTimeoutClient({required this.timeout});

  final http.Client _inner = http.Client();
  final Duration timeout;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request).timeout(timeout);

  @override
  close() {
    _inner.close();
    super.close();
  }
}
