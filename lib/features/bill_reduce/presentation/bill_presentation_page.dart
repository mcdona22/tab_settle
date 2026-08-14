import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/utils.dart';
import 'package:tab_settle/features/home/home_page.dart';

class BillPresentationPage extends HookConsumerWidget with UiLoggy {
  const BillPresentationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: createAppBar(context, ScreenTitle(label: 'Ready to Share')),
    );
  }
}
