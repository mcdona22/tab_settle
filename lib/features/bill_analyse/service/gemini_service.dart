import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/service/generative_model_provider.dart';

part 'gemini_service.g.dart';

// curl "https://generativelanguage.googleapis.com/v1beta/models?key=AQ.Ab8RN6J7ZXCc3D8OkscW8E9JIck9qj4LBNO4BtvcrnB6-DSD2Q

@Riverpod(keepAlive: true)
GeminiService geminiService(Ref ref) =>
    GeminiService(model: ref.watch(receiptGenerativeModelProvider))..warmUp();

class GeminiService with UiLoggy {
  final GenerativeModel model;

  GeminiService({required this.model});

  Future<void> warmUp() async {
    // Ultra-lightweight call just to establish HTTP Keep-Alive
    loggy.debug('Warming up the service');
    await model.generateContent([Content.text('ping')]);
    loggy.debug('warmup complete');
  }

  Future<Map<String, dynamic>> analyseTextReceipt(String textReceipt) async {
    loggy.debug('analysing using "$modelVersion"');
    final prompt = _buildFastReceiptPrompt(textReceipt);
    loggy.info('submitting request for');
    final response = await model.generateContent([Content.text(prompt)]);
    if (response.text == null || response.text!.isEmpty) {
      loggy.error('Gemini error occurred');
      throw Exception('Gemini Exception');
    }
    final json = jsonDecode(response.text!) as Map<String, dynamic>;
    loggy.debug("Response found", json);
    return json;
  }

  String _buildFastReceiptPrompt(String rawText) {
    return '''
Extract structured receipt data from raw text into JSON.

SPEED & EXECUTION DIRECTIVE:
- Do NOT perform internal reasoning, planning, or step-by-step thinking.
- Output the raw JSON schema directly in a single pass.
- Default unreadable names to "Unknown Item" and unreadable prices to 0.0 without calculating.

RAW TEXT:
$rawText
''';
  }
}
