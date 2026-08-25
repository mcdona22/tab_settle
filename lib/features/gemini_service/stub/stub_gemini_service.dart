import 'dart:async';
import 'dart:math';

import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/stub/stub_receipt_dtos.dart';

import '../i_gemini_service.dart';

class StubGeminiService with UiLoggy implements IGeminiService {
  final Random _random = Random();

  @override
  Future<ReceiptDto> analyseAssetReceipt(String path) async {
    loggy.debug('Using StubGeminiService - returning canned DTO');

    // Simulate a slight network delay (300ms) for realistic UX testing
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    return stubReceiptDtos[_random.nextInt(stubReceiptDtos.length)];
  }
}
