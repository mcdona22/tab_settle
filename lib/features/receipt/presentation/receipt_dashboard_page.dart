import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/async_value_widget.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';
import 'package:tab_settle/features/receipt/presentation/providers.dart';
import 'package:tab_settle/features/receipt/presentation/receipt_Items_list.dart';
import 'package:tab_settle/features/receipt/presentation/user_handle.dart';

final options = ['Available', 'My Claims', 'Every Ones'];

class ReceiptDashboardPage extends HookConsumerWidget with UiLoggy {
  const ReceiptDashboardPage({required this.receiptId, super.key});

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userHandle = ref.watch(userHandleControllerProvider);
    final receiptHeader = ref.watch(receiptHeaderProvider(receiptId));
    final receiptItems = ref.watch(receiptItemsProvider(receiptId));
    final tabBarIndex = useState<int>(0);

    return Scaffold(
      appBar: createAppBar(
        context,
        ScreenTitle(label: 'Claim Your Items'),
        // toolbarHeight: 60.0,
      ),

      body: MobileFirstContainer(
        child: Column(
          children: [
            UserHandle(),
            // AsyncValueWidget(
            //   value: receiptHeader,
            //   data: (receipt) {
            //     return ReceiptHeader(receipt: receipt);
            //   },
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: AsyncValueWidget(
                  value: receiptItems,
                  data: (items) => Column(
                    children: [
                      ReceiptItemsList(items: items),
                      Divider(),
                      Text('Claimed Items'),
                      ReceiptItemsList(items: items, userFilter: userHandle),
                    ],
                  ),
                ),
              ),
            ),
            // DebugContainer(child: Center(child: Text('remainder'))),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabBarIndex.value,
        items: List.generate(options.length, (i) {
          return BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: options[i],
          );
        }),
        onTap: (index) => tabBarIndex.value = index,
      ),
    );
  }
}

class ReceiptHeader extends StatelessWidget {
  const ReceiptHeader({required this.receipt, super.key});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 12.0,
            children: [
              Text(receipt.title, style: textTheme.titleLarge),
              Text(
                'Total: ${receipt.totalAmount.toCurrency()}',
                style: textTheme.titleSmall,
              ),
              Text(
                'Service: ${receipt.serviceCharge.toCurrency()}',
                style: textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
