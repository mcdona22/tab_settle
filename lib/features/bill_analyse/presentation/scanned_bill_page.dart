import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/core/routing/router.dart';
import 'package:tab_settle/features/bill_analyse/application/bill_scan_provider.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/receipt_dto_overview.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_controller.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

class ScannedBillPage extends HookConsumerWidget with UiLoggy {
  const ScannedBillPage({required this.filePath, super.key});

  final String filePath;

  // final ReceiptDto dto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dtoState = ref.watch(receiptScanProvider(filePath));
    final controllerState = ref.watch(scannedBillControllerProvider);
    // final file = useMemoized(() => File(filePath), [filePath]);
    return Scaffold(
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
              Text(
                dtoState.hasValue
                    ? dtoState.value!.isBogus
                          ? 'This receipt has no items - are you giving me a bogus '
                                'receipt?'
                          : 'Please check the scan matches the receipt and correct '
                                'before sharing'
                    : 'processing the receipt',
                textAlign: TextAlign.center,
              ),

              Expanded(
                child: AsyncValueWidget<ReceiptDto>(
                  value: dtoState,
                  data: (dto) => dto.isBogus
                      ? crossPlatformPathImage(filePath)!
                      : ReceiptDtoView(dto: dto),
                ),
              ),

              if (dtoState.value != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ActionButton(label: 'Edit'),

                    AsyncValueWidget(
                      value: controllerState,

                      data: (_) => ActionButton(
                        label: 'Next',
                        onPressed: () => _onSavePressed(
                          context,
                          ref,
                          Receipt.fromDto(dtoState.value!),
                        ),
                        //   onPressed: () async {
                        //     final receipt = Receipt.fromDto(dtoState.value!);
                        //     final controller = ref.read(
                        //       scannedBillControllerProvider.notifier,
                        //     );
                        //     final id = await controller.saveReceipt(receipt);
                        //     if (id.isNotEmpty && context.mounted) {
                        //       context.pushNamed(
                        //         AppRoute.receiptDashboard.name,
                        //         pathParameters: {'id': id},
                        //       );
                        //     }
                        //   },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSavePressed(
    BuildContext context,
    WidgetRef ref,
    Receipt receipt,
  ) async {
    final receiptId = await ref
        .read(scannedBillControllerProvider.notifier)
        .saveReceipt(receipt);

    if (!context.mounted) return;

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
