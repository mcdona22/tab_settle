import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:qr_bar_code/qr/qr.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/features/receipt_dashboard/application/receipt_service.dart';
import 'package:tab_settle/features/receipt_dashboard/presentation/widgets/receipt_header.dart';

class DashboardShareView extends HookConsumerWidget with UiLoggy {
  const DashboardShareView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
    final receiptState = ref.watch(receiptHeaderProvider(receiptId));
    final url = 'google.com';
    final theme = Theme.of(context);

    void onSharePressed() {
      Share.share(
        'Join my receipt on Tabshare: $url',
        subject:
            'Sharing the '
            'receipt',
      );
    }

    return SingleChildScrollView(
      child: Column(
        spacing: 18.0,
        children: [
          AsyncValueWidget(
            value: receiptState,
            data: (receipt) => ReceiptHeader(receipt: receipt),
          ),
          Text('Share with your peeps', style: theme.textTheme.displaySmall),
          QRCode(
            data: url,
            size: 180.0,
            padding: EdgeInsets.all(12.0),
            backgroundColor: theme.colorScheme.secondaryFixedDim,
          ),
          // SelectableText(
          //   'www.tabshare/receipt/$receiptId',
          //   style: theme.textTheme.titleLarge,
          // ),
          IconButton.filledTonal(
            onPressed: onSharePressed,
            icon: const Icon(Icons.share, size: 30.0),
          ),

          // child: const Text('Share Link')
        ],
      ),
    );
  }
}
