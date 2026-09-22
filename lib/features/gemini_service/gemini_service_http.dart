import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/auth_service.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/exceptions/gemini_exception.dart';
import 'package:tab_settle/features/gemini_service/i_gemini_service.dart';

enum NetworkQuality { strong, poor, offline }

class GeminiServiceHttp with UiLoggy implements IGeminiService {
  static final performanceTestEndpoint = 'https://www.google.com/generate_204';
  final String baseUrl;
  final http.Client _client;
  final AuthService authService;

  GeminiServiceHttp({
    required this.baseUrl,
    http.Client? client,
    required this.authService,
  }) : _client = client ?? http.Client();

  @override
  Future<ReceiptDto> analyseAssetReceipt(XFile xFile) async {
    final authToken = await authService.getIdToken();
    final fileName = xFile.name;
    loggy.debug('analysing receipt via http for asset: $fileName');
    loggy.debug('Using the endpoint $baseUrl');
    loggy.debug('adding auth token "$authToken"');
    final uri = Uri.parse('$baseUrl/receipt/analyse');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $authToken';

    try {
      final bytes = await xFile.readAsBytes();

      final extension = fileName.split('.').last.toLowerCase();
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: http.MediaType('image', _getMediaTypeSubtype(extension)),
      );

      request.files.add(multipartFile);

      loggy.debug('Posting multipart request to $uri');
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != HttpStatus.created) {
        throwGeminiException(response);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        loggy.debug('201 from the service');
        loggy.debug('json : $jsonMap');
        return ReceiptDto.fromJson(jsonMap);
      } else {
        final errorString = 'status ${response.statusCode} : ${response.body}';
        loggy.warning('Server return error - $errorString');
        throw Exception('Failed to analyse receipt - $errorString');
      }
    } on GeminiException catch (_) {
      rethrow;
    } catch (e, st) {
      loggy.error('Error analysing receipt file', e, st);
      throw GeminiUnknownException(e);
    }
  }

  Future<NetworkQuality> getNetworkQuality() async {
    loggy.debug('getting network quality');
    const timeoutDuration = Duration(milliseconds: 3500);
    const strongThresholdMs = 1000;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final url = Uri.parse('$performanceTestEndpoint?_=$timestamp');
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client.head(url).timeout(timeoutDuration);
      stopwatch.stop();
      if (response.statusCode == 204 &&
          stopwatch.elapsedMilliseconds < strongThresholdMs) {
        return NetworkQuality.strong;
        // Connection is fast and responsive
      }
      //between strong threshold and the timeout Duration
      return NetworkQuality.poor;
    } on TimeoutException {
      return NetworkQuality.poor;
    } on SocketException {
      return NetworkQuality.offline;
    } catch (_) {
      return NetworkQuality.offline;
    }

    return NetworkQuality.poor;
  }

  String _getMediaTypeSubtype(String extension) {
    switch (extension) {
      case 'png':
        return 'png';
      case 'heic':
        return 'heic';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }

  void throwGeminiException(http.Response response) {
    loggy.debug('processing bad code (${response.statusCode})');
    loggy.debug(response.body);
    final json = jsonDecode(response.body);
    loggy.debug('json', json);
    switch (response.statusCode) {
      case 503:
        throw GeminiServiceOverloadException();

      default:
        throw GeminiUnknownException(response);
    }
  }
}
