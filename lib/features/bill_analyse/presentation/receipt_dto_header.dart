import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/ui_dimensions.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/presentation/name_edit_control.dart';
import 'package:tab_settle/features/bill_analyse/presentation/scanned_bill_page.dart';

class ReceiptDtoHeader extends StatelessWidget with UiLoggy {
  final ReceiptDto dto;

  const ReceiptDtoHeader({required this.dto, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mobileWidth,
      child: Card(
        child: Container(
          decoration: dto.hasDiscrepancy ? correctionOutline(context) : null,

          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: colSpacingSmall,
              children: [
                // Text(
                //   dto.merchantName,
                //   style: Theme.of(context).textTheme.titleLarge,
                //   textAlign: TextAlign.center,
                // ),
                NameEditControl(),
                SummaryLine(
                  fixed: Text(
                    dto.totalAmount.toCurrency(),
                    textAlign: TextAlign.right,
                  ),
                  remaining: Text('Total'),
                ),
                SummaryLine(
                  remaining: Text('Service Charge'),
                  fixed: Text(
                    dto.serviceCharge.toCurrency(),
                    textAlign: TextAlign.right,
                  ),
                ),

                if (dto.serviceCharge > 0.0)
                  SummaryLine(
                    remaining: Text('Service Rate'),
                    fixed: Text(
                      '${dto.serviceChargePercentage.toString()} %',
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
