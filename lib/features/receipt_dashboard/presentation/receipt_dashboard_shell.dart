import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tab_settle/features/receipt_dashboard/application/receipt_service.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/receipt_dashboard_page.dart';

class ReceiptDashboardShell extends StatelessWidget {
  const ReceiptDashboardShell({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [receiptIdProvider.overrideWithValue(receiptId)],
      child: ReceiptDashboardPage(),
    );
  }
}
