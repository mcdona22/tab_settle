import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';

class ScannedBillPage extends HookConsumerWidget with UiLoggy {
  const ScannedBillPage({required this.dto, super.key});

  final ReceiptDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: createAppBar(context, 'Check the Bill'),
      body: Center(child: Text('Check the receipt for ${dto.merchantName}')),
    );
  }
}
