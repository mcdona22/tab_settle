import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/extensions/map.extensions.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/generative_model_provider.dart';

import 'i_gemini_service.dart';

// part 'gemini_service.g.dart';

// @Riverpod(keepAlive: true)
// GeminiService geminiService(Ref ref) => GeminiService(
//   ref: ref,
//   // handle: ref.watch(receiptGenerativeModelHandleProvider),
// );

class GeminiService with UiLoggy implements IGeminiService {
  final Ref ref;

  // final GenerativeModelHandle handle;
  static const Duration requestTimeout = Duration(milliseconds: 30000);

  GeminiService({required this.ref});

  // Future<void> warmUp() async {
  //   // Ultra-lightweight call just to establish HTTP Keep-Alive
  //   loggy.debug('Warming up the service');
  //   await handle.model.generateContent([Content.text('ping')]);
  //   loggy.debug('warmup complete');
  // }
  @override
  Future<ReceiptDto> analyseAssetReceipt(String path) async {
    final byteData = await XFile(path).readAsBytes();
    final bytes = byteData.buffer.asUint8List();
    final sharpened = _processReceiptForOcr(bytes);
    final String mimeType = 'image/jpeg';
    final client = http.Client();
    // final client = NonRetryingTimeoutClient(timeout: requestTimeout);
    final modelBuilder = ref.read(receiptModelBuilderProvider);
    final model = modelBuilder(client);

    loggy.debug('analysing receipt');
    loggy.debug('Using a timeout of ${requestTimeout.inSeconds} seconds');
    final completer = Completer<GenerateContentResponse>();

    model
        .generateContent([
          Content.multi([TextPart(prompt), DataPart(mimeType, sharpened)]),
        ])
        .then((response) {
          if (!completer.isCompleted) completer.complete(response);
        })
        .catchError((e, st) {
          if (!completer.isCompleted) {
            completer.completeError(e, st);
          }
        });

    // final operation = CancelableOperation.fromFuture(
    //   model.generateContent([
    //     Content.multi([TextPart(prompt), DataPart(mimeType, sharpened)]),
    //   ]),
    // );

    final timeoutCompleter = Completer<Never>();
    final timer = Timer(requestTimeout, () {
      loggy.error(
        'Receipt service timed out after ${requestTimeout.inMilliseconds}',
      );
      // operation.cancel();
      client.close();
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('We havent completed before the timer expired'),
        );
      }
    });

    try {
      // final response = await operation.valueOrCancellation();
      final response = await completer.future;

      if (response.text == null || response.text!.isEmpty) {
        loggy.error('Receipt analysis error occurred processing image file');
        throw Exception('Receipt Analysis');
      }
      final json = jsonDecode(response.text!) as Map<String, dynamic>;
      loggy.debug(json.toPrettyJson);
      final dto = ReceiptDto.fromJson(json);
      loggy.debug("Response found");
      loggy.debug('DTO: \n$dto');
      return dto;
    } on http.ClientException {
      throw TimeoutException('Analysis took too long');
    } finally {
      timer.cancel();
      client.close();
    }
  }

  Uint8List _processReceiptForOcr(Uint8List rawBytes) {
    final decodedImage = img.decodeImage(rawBytes);
    if (decodedImage == null) {
      loggy.debug('Decoding failed - returning original image');
    }
    final greyScale = img.grayscale(decodedImage!);
    final sharpened = img.adjustColor(greyScale, contrast: 1.5);
    return Uint8List.fromList(img.encodeJpg(sharpened, quality: 90));
  }

  // String _buildFastReceiptPrompt(String rawText) {
  //   return ' $prompt\nRAWTEXT: $rawText \nRAW TEXT:$rawText';
  // }

  // Future<List<String>> listAvailableModels(String apiKey) async {
  //   final url = Uri.parse(
  //     'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
  //   );
  //   List<dynamic> models = [];
  //
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       // models = data['models'] as List<dynamic>?;
  //       models = data['models'] as List<dynamic>;
  //
  //       loggy.debug('=== AVAILABLE MODELS ===');
  //       // if (models != null) {
  //       if (models.isNotEmpty) {
  //         for (final m in models) {
  //           final name = m['name'] as String; // e.g., "models/gemini-1.5-flash"
  //           final supportedMethods =
  //               m['supportedGenerationMethods'] as List<dynamic>?;
  //
  //           // Print models that support content generation
  //           if (supportedMethods?.contains('generateContent') ?? false) {
  //             // loggy.debug(name.replaceFirst('models/', ''));
  //             null;
  //           }
  //         }
  //       }
  //     } else {
  //       loggy.debug(
  //         'Failed to fetch models: ${response.statusCode} - ${response.body}',
  //       );
  //     }
  //   } catch (e) {
  //     loggy.error('Error listing models: $e');
  //   }
  //
  //   loggy.debug('we have ${models.length} models');
  //   return models.map((m) {
  //     final name = m['name'] as String;
  //     return name.replaceFirst('models/', '');
  //   }).toList();
  // }
}

const prompt = '''
You are a high-precision OCR system. Extract receipt data strictly from visible printed text.

MATHEMATICAL INTEGRITY & DISCREPANCY DIRECTIVES:
- Prioritize VISUAL TRUTH over MATHEMATICAL RECONCILIATION.
- NEVER alter, invent, or adjust item prices or quantities to make the items sum up to the Grand Total.
- If an item's price or text is blurry, truncated, or faint:
  1. Transcribe your best literal read of the characters.
  2. Set "hasDiscrepancy": true for that specific item.
 - Calculate the mathematical sum of the extracted items (+ service charge)

  ROOT DISCREPANCY EVALUATION:

- IF (sum != totalAmount) OR (any item has "hasDiscrepancy": true):
  Do NOT tweak the numbers to fix the math
    Set root "hasDiscrepancy": true.
    Set "discrepancyDescription": "Brief explanation of mismatch".
- ELSE:
    Set root "hasDiscrepancy": false.
    Set "discrepancyDescription": ''.
 
 
STRICT ACCURACY DIRECTIVES:
- Transcribe ONLY characters that are physically visible in the image.
- NEVER invent, guess, or synthesize items based on the restaurant name or type.
- If item text is too faint, blurry, or unreadable, do NOT guess menu items like pizza or beer. Set the item fields to null or flag them.
- Focus ONLY on the primary receipt in the center/foreground. Ignore secondary receipts or background paper on the left/right.
- Check item prices carefully against the right-hand column (e.g., £11.00, £9.80, £18.00, £16.00).
''';

const prompt1 = '''
You are an expert document OCR engine. Analyze the provided image of the receipt carefully and extract all transaction details into JSON according to the schema.

VISUAL EXTRACTION RULES:
1. Scan the receipt line by line from top to bottom.
2. The Merchant Name is printed at the top (e.g., "Toby Carvery").
3. For each purchase item, extract:
   - Name (e.g., "ULSD Sugar Free", "Pineap Jce med", "Brownie Sundae", "Midweek Carvery", "King Size Upgrde")
   - Quantity (integer listed before or next to the item name, e.g., 1)
   - Price (the item price listed on the right column, e.g., 4.15, 3.30, 5.79, 11.29, 1.99)
4. Do NOT include subtotal headers, tax summary lines (like "20% VAT"), or product group summaries ("Food And Drink") in the item array.
5. Extract the grand Total printed at the bottom (£26.52).
6. Do NOT guess or substitute values from other store templates. Extract ONLY what is visible on this physical slip.
''';
