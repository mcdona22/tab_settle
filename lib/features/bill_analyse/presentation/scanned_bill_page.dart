import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_overview.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receiptdto_edit_controller.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_controller.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';

class ScannedBillPage extends HookConsumerWidget with UiLoggy {
  const ScannedBillPage({required this.dto, super.key});

  final ReceiptDto dto;

  // final ReceiptDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() {
        ref.read(receiptDtoEditControllerProvider.notifier).init(dto);
      });
      return null;
    }, const []);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: createAppBar(context, ScreenTitle(label: 'Process the Receipt')),

      body: MobileFirstContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kPaddingSmall,
            vertical: kPaddingMedium,
          ),
          child: Column(
            spacing: colSpacingSmall,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: ReceiptDtoView(dto: dto)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButton(label: 'Edit'),

                  ActionButton(
                    label: 'Next',
                    onPressed: () {
                      final receipt = Receipt.fromDto(
                        ref.watch(receiptDtoEditControllerProvider)!,
                      );
                      loggy.debug('Saving receipt to db', receipt.title);
                      _onNext(context, ref, receipt);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onNext(
    BuildContext context,
    WidgetRef ref,
    Receipt receipt,
  ) async {
    final receiptId = await ref
        .read(scannedBillControllerProvider.notifier)
        .saveReceipt(receipt);
    loggy.debug('Saved the receipt $receiptId');

    if (!context.mounted) return;
    loggy.debug('navigating');
    context.goNamed(
      AppRoute.receiptDashboard.name,
      pathParameters: {'id': receiptId},
    );
  }
}

class SummaryLine extends StatelessWidget with UiLoggy {
  const SummaryLine({
    this.fixedWidth = 80.0,
    this.fixed,
    this.remaining,
    super.key,
  });

  final Widget? fixed;
  final Widget? remaining;
  final double fixedWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        spacing: kPaddingMedium,
        children: [
          SizedBox(width: fixedWidth, child: fixed ?? SizedBox.shrink()),
          Expanded(child: remaining ?? SizedBox.shrink()),
        ],
      ),
    );
  }
}
