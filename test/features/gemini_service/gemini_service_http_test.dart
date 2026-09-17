import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tab_settle/features/auth_service.dart';
import 'package:tab_settle/features/gemini_service/gemini_service_http.dart';

import 'gemini_service_http_test.mocks.dart';

@GenerateMocks([http.Client, AuthService])
void main() {
  late MockClient mockHttpClient;
  late MockAuthService mockAuthService;
  late GeminiServiceHttp geminiService;

  const baseUrl = 'http://api.mock-endpoint.com';
  const authToken = 'mock-firebase-auth-token';

  setUp(() {
    mockHttpClient = MockClient();
    mockAuthService = MockAuthService();
    when(mockAuthService.getIdToken()).thenAnswer((_) async => authToken);

    geminiService = GeminiServiceHttp(
      baseUrl: baseUrl,
      authService: mockAuthService,
      client: mockHttpClient,
    );
  });

  group('Gemini Service simple', () {
    test(
      'should create the service',
      () async => expect(geminiService, isNotNull),
    );
  });
}
