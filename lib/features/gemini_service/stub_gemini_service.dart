import 'dart:async';

import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_item_dto.dart';

import 'i_gemini_service.dart';

class StubGeminiService with UiLoggy implements IGeminiService {
  @override
  Future<ReceiptDto> analyseAssetReceipt(String path) async {
    loggy.debug('Using StubGeminiService - returning canned DTO');

    // Simulate a slight network delay (300ms) for realistic UX testing
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return ReceiptDto(
      merchantName: 'Toby Carvery Castle View',
      currency: '£',
      subtotal: 26.52,
      serviceCharge: 0.0,
      totalAmount: 26.52,
      hasDiscrepancy: false,
      hasFallbackValues: false,
      items: const [
        ReceiptItemDto(
          name: 'Midweek Carvery',
          quantity: 2,
          price: 22.58,
          hasDiscrepancy: false,
          hasFallbackValues: false,
        ),
        ReceiptItemDto(
          name: 'ULSD Sugar Free',
          quantity: 1,
          price: 3.94,
          hasDiscrepancy: false,
          hasFallbackValues: false,
        ),
      ],
    );
  }
}
