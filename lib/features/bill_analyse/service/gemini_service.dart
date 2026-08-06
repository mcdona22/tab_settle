import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/service/generative_model_provider.dart';

part 'gemini_service.g.dart';

@Riverpod(keepAlive: true)
GeminiService geminiService(Ref ref) =>
    // GeminiService(model: ref.watch(receiptGenerativeModelProvider))..warmUp();
    GeminiService(model: ref.watch(receiptGenerativeModelProvider));

class GeminiService with UiLoggy {
  final GenerativeModel model;

  GeminiService({required this.model});

  Future<void> warmUp() async {
    // Ultra-lightweight call just to establish HTTP Keep-Alive
    loggy.debug('Warming up the service');
    await model.generateContent([Content.text('ping')]);
    loggy.debug('warmup complete');
  }

  Future<ReceiptDto> analyseTextReceipt(String textReceipt) async {
    loggy.debug('analysing using "$modelVersion"');
    final prompt = _buildFastReceiptPrompt(textReceipt);
    loggy.info('submitting request for');
    final response = await model.generateContent([Content.text(prompt)]);
    if (response.text == null || response.text!.isEmpty) {
      loggy.error('Gemini error occurred');
      throw Exception('Gemini Exception');
    }
    final json = jsonDecode(response.text!) as Map<String, dynamic>;
    final dto = ReceiptDto.fromJson(json);
    loggy.debug("Response found");
    loggy.debug('DTO: \n$dto');
    return dto;
  }

  Future<ReceiptDto> analyzeAssetReceipt(String path) async {
    final ByteData byteData = await rootBundle.load(path);
    final Uint8List bytes = byteData.buffer.asUint8List();
    final String mimeType = 'image/jpeg';

    final response = await model.generateContent([
      Content.multi([TextPart(prompt), DataPart(mimeType, bytes)]),
    ]);

    if (response.text == null || response.text!.isEmpty) {
      loggy.error('Gemini error occurred processing image file');
      throw Exception('Gemini Exception');
    }

    final json = jsonDecode(response.text!) as Map<String, dynamic>;
    final dto = ReceiptDto.fromJson(json);
    loggy.debug("Response found");
    loggy.debug('DTO: \n$dto');
    return dto;
  }

  String _buildFastReceiptPrompt(String rawText) {
    return ' $prompt\nRAWTEXT: $rawText \nRAW TEXT:$rawText';
  }

  Future<List<String>> listAvailableModels(String apiKey) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
    );
    List<dynamic> models = [];

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // models = data['models'] as List<dynamic>?;
        models = data['models'] as List<dynamic>;

        loggy.debug('=== AVAILABLE MODELS ===');
        // if (models != null) {
        if (models.isNotEmpty) {
          for (final m in models) {
            final name = m['name'] as String; // e.g., "models/gemini-1.5-flash"
            final supportedMethods =
                m['supportedGenerationMethods'] as List<dynamic>?;

            // Print models that support content generation
            if (supportedMethods?.contains('generateContent') ?? false) {
              // loggy.debug(name.replaceFirst('models/', ''));
              null;
            }
          }
        }
      } else {
        loggy.debug(
          'Failed to fetch models: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      loggy.error('Error listing models: $e');
    }

    loggy.debug('we have ${models.length} models');
    return models.map((m) {
      final name = m['name'] as String;
      return name.replaceFirst('models/', '');
    }).toList();
  }
}

const prompt = '''Extract structured receipt data from raw text into JSON.

SPEED & EXECUTION DIRECTIVE:
- Do NOT perform internal reasoning, planning, or step-by-step thinking.
- Output the raw JSON schema directly in a single pass.
- If a value (like item name, price, or quantity) is unreadable, obscured, or missing, output null for that field.
EXTRACTION DIRECTIVES:
- Do NOT list service charges, gratuities, or discretionary tips as items in the 'items' array.
- Extract any explicit service charge or gratuity into 'serviceCharge'.
- Extract the subtotal before service charge into 'subtotal' if available.
''';
