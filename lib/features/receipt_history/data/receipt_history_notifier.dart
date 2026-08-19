import 'dart:convert';

import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/application/user_handle_notifier.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

part 'receipt_history_notifier.g.dart';

@riverpod
class ReceiptHistoryNotifier extends _$ReceiptHistoryNotifier with UiLoggy {
  final _key = 'com.mcdona22.tab_settle.receipt_history';

  @override
  FutureOr<List<Receipt>> build() async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final rawJson = prefs.getStringList(_key) ?? [];
    final currentHistory = rawJson
        .map((item) => Receipt.fromJson(jsonDecode(item)))
        .toList();
    loggy.debug('Found history', currentHistory);
    return currentHistory;
  }
}
