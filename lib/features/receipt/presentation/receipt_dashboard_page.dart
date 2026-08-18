import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/extensions/double.extensions.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';
import 'package:tab_settle/features/receipt/presentation/dashboard_views/dashboard_claim_view.dart';
import 'package:tab_settle/features/receipt/presentation/dashboard_views/dashboard_summary_view.dart';
import 'package:tab_settle/features/receipt/presentation/user_handle.dart';

final options = ['Overview', 'My Claims'];

class ReceiptDashboardPage extends HookConsumerWidget with UiLoggy {
  const ReceiptDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = const [DashboardSummaryView(), DashboardClaimView()];
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

            Expanded(
              child: SingleChildScrollView(
                child: IndexedStack(index: tabBarIndex.value, children: views),
              ),
            ),
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
