import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

part 'receipt_history_notifier.g.dart';

@riverpod
class ReceiptHistoryNotifier extends _$ReceiptHistoryNotifier with UiLoggy {
  static const _key = 'com.mcdona22.tab_settle.receipt_history';

  @override
  List<Receipt> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawJson = prefs.getStringList(_key) ?? [];
    final currentHistory = rawJson
        .map((item) => Receipt.fromJson(jsonDecode(item)))
        .toList();
    loggy.debug('Found history', currentHistory);
    return currentHistory;
  }

  void addVisitedReceipt(Receipt receipt) {
    final exists = state.any((item) => item.id == receipt.id);

    if (exists) return;
    final r = receipt.toFirestoreDocument();

    final newHistory = [receipt.copyWith(items: []), ...state];
    state = newHistory;
    _persist(newHistory);
  }

  void clear() async {
    await ref.read(sharedPreferencesProvider).clear();
    loggy.debug('Shared prefs cleared');
  }

  void _persist(List<Receipt> list) {
    loggy.debug('persisting history');

    final prefs = ref.read(sharedPreferencesProvider);
    final rawJson = list
        .map((receipt) => jsonEncode(receipt.toJson()))
        .toList();

    prefs.setStringList(_key, rawJson).then((success) => null);
  }
}
