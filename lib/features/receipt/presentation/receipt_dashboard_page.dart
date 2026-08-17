import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/utils.dart';

class ReceiptDashboardPage extends HookConsumerWidget with UiLoggy {
  const ReceiptDashboardPage({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Claim Your Items')),
      body: MobileFirstContainer(
        child: Center(child: Text("ID is $receiptId")),
      ),
    );
  }
}
