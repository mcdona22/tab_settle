import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tab_settle/features/auth_service.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
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

  /*
  Helpers
   */
  XFile _createFakeXFile({String name = 'test_receipt.jpg'}) {
    return XFile.fromData(
      Uint8List.fromList([1, 2, 3, 4]),
      name: name,
      mimeType: 'image/jpeg',
    );
  }

  http.StreamedResponse _createStreamedResponse({
    required int statusCode,
    required String body,
  }) {
    final stream = Stream.value(utf8.encode(body));
    return http.StreamedResponse(stream, statusCode);
  }

  /*
  Tests
   */
  group('Gemini Service happy path', () {
    test(
      'should create the service',
      () async => expect(geminiService, isNotNull),
    );

    test('Successful call to gemini service', () async {
      final fakeXFile = _createFakeXFile();
      final mockJsonResponse = jsonEncode({
        'id': '123',
        'merchantName': 'Coffee Shop',
        'totalAmount': 12.50,
        'items': [],
      });

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            _createStreamedResponse(statusCode: 201, body: mockJsonResponse),
      );

      final result = await geminiService.analyseAssetReceipt(fakeXFile);
      expect(result, isA<ReceiptDto>());
      verify(mockAuthService.getIdToken()).called(1);
      verify(mockHttpClient.send(any)).called(1);
    });
  });

  group('Test bandwidth before request submission', () {
    test(
      'should request as normal for good bandwidth',
      () async {},
      skip: true,
    );
    test(
      'should not make request with insufficient bandwidth',
      () async {},
      skip: true,
    );
  });
}
