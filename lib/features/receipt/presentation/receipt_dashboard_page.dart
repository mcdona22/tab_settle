import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/mobile_first_container.dart';
import 'package:tab_settle/core/presentation/screen_title.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/presentation/dashboard_views/views.dart';
import 'package:tab_settle/features/receipt/presentation/widgets/user_handle.dart';

class ReceiptDashboardPage extends HookConsumerWidget with UiLoggy {
  const ReceiptDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptId = ref.watch(receiptIdProvider);
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
                child: IndexedStack(
                  index: tabBarIndex.value,
                  children: DashboardTab.values.map((tab) => tab.view).toList(),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabBarIndex.value,
        iconSize: 20.0,
        // Reduced from default 24.0
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        elevation: 2.0,
        type: BottomNavigationBarType.fixed,

        // Keeps dimensions uniform
        items: DashboardTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          );
        }).toList(),

        onTap: (index) => tabBarIndex.value = index,
      ),
    );
  }
}
