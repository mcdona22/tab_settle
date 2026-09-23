import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tab_settle/features/auth_service.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/exceptions/gemini_exception.dart';
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
  XFile createFakeXFile({String name = 'test_receipt.jpg'}) {
    return XFile.fromData(
      Uint8List.fromList([1, 2, 3, 4]),
      name: name,
      mimeType: 'image/jpeg',
    );
  }

  // final Matcher isPreflight = predicate<http.BaseRequest>(
  //   (req) => req.url.toString().startsWith(
  //     GeminiServiceHttp.performanceTestEndpoint,
  //   ),
  // );
  //
  // final Matcher isApi = predicate<http.BaseRequest>(
  //   (req) => !req.url.toString().startsWith(
  //     GeminiServiceHttp.performanceTestEndpoint,
  //   ),
  // );

  http.StreamedResponse createStreamedResponse({
    required int statusCode,
    required String body,
  }) {
    final stream = Stream.value(utf8.encode(body));
    return http.StreamedResponse(stream, statusCode);
  }

  http.Client createMockClient({
    Duration preflightDelay = Duration.zero,
    int preflightStatus = 204,
    http.Response? apiResponse,
    bool simulateOffline = false,
  }) {
    return http_testing.MockClient((request) async {
      if (request.url.toString().startsWith(
        GeminiServiceHttp.performanceTestEndpoint,
      )) {
        if (simulateOffline) {
          throw const SocketException('mocked no network');
        }

        if (preflightDelay.inMilliseconds > 3500) {
          throw TimeoutException('mocked timeout exception');
        }
        if (preflightDelay > Duration.zero) {
          await Future.delayed(preflightDelay);
        }
        return http.Response('', preflightStatus);
      }

      return apiResponse ?? http.Response('{"status": "ok"}', 200);
    });
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
      final fakeXFile = createFakeXFile();
      final mockJsonResponse = jsonEncode({
        'id': '123',
        'merchantName': 'Coffee Shop',
        'totalAmount': 12.50,
        'items': [],
      });

      when(
        mockHttpClient.head(any, headers: anyNamed('headers')),
      ).thenAnswer((_) async => http.Response('', 204));

      when(mockHttpClient.send(any)).thenAnswer(
        (_) async =>
            createStreamedResponse(statusCode: 201, body: mockJsonResponse),
      );

      final result = await geminiService.analyseAssetReceipt(fakeXFile);
      expect(result, isA<ReceiptDto>());
      verify(mockAuthService.getIdToken()).called(1);
      verify(mockHttpClient.send(any)).called(1);
    });
  });

  group('Test bandwidth before request submission', () {
    final fakeXFile = createFakeXFile();

    // test('should request as normal for good bandwidth', () async {
    //   final client = createMockClient();
    //   final service = GeminiServiceHttp(
    //     baseUrl: baseUrl,
    //     authService: mockAuthService,
    //     client: client,
    //   );
    //
    //   final quality = await service.getNetworkQuality();
    //   expect(quality, (NetworkQuality.strong));
    // });

    test('should not make request with insufficient bandwidth', () async {
      final client = createMockClient(
        // simulateOffline: true,
        preflightDelay: Duration(milliseconds: 1100),
      );
      final service = GeminiServiceHttp(
        baseUrl: baseUrl,
        authService: mockAuthService,
        client: client,
      );

      await expectLater(
        () async => await service.analyseAssetReceipt(fakeXFile),
        throwsA(isA<GeminiNetworkException>()),
      );

      verifyNever(mockAuthService.getIdToken());
      verifyNever(mockHttpClient.send(any));
    });

    test('should not make request when no bandwidth detected', () async {
      final client = createMockClient(simulateOffline: true);
      final service = GeminiServiceHttp(
        baseUrl: baseUrl,
        authService: mockAuthService,
        client: client,
      );

      await expectLater(
        () async => await service.analyseAssetReceipt(fakeXFile),
        throwsA(isA<GeminiOfflineException>()),
      );

      verifyNever(mockAuthService.getIdToken());
      verifyNever(mockHttpClient.send(any));
    });
  });
}
