import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/i_gemini_service.dart';

class GeminiServiceHttp with UiLoggy implements IGeminiService {
  final String baseUrl;
  final http.Client _client;

  GeminiServiceHttp({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  @override
  Future<ReceiptDto> analyseAssetReceipt(XFile xFile) async {
    final fileName = xFile.name;
    loggy.debug('analysing receipt via http for asset: $fileName');
    loggy.debug('Using the endpoint $baseUrl');
    final uri = Uri.parse('$baseUrl/receipt/analyse');
    final request = http.MultipartRequest('POST', uri);
    // final file = File(path);
    // if (!await file.exists()) {
    //   loggy.error('File does not exist at path: $fileName');
    //   throw FileSystemException('Receipt image file not found', fileName);
    // } else {
    //   loggy.debug('File "$path" is not reachable');
    // }

    try {
      final bytes = await xFile.readAsBytes();

      // final filename = fileName.split(Platform.pathSeparator).last;
      final extension = fileName.split('.').last.toLowerCase();
      final multipartFile = await http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: http.MediaType('image', _getMediaTypeSubtype(extension)),
      );

      request.files.add(multipartFile);

      loggy.debug('Posting multipart request to $uri');
      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

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
    } catch (e, st) {
      loggy.error('Error analysing receipt file', e, st);
      rethrow;
    }
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
}
