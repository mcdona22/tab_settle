import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/centred_constrained_widget.dart';

class HomePage extends HookConsumerWidget with UiLoggy {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    loggy.info('Rendering HomePage baseline');
    final buttonWidth = 160.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Tab Settle'), centerTitle: true),
      body: SingleChildScrollView(

        padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
        child: CentredConstrainedWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 28.0,
            children: [
                     Icon(
                      Icons.rocket_launch_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme
                          .secondary,
                    ),
                    Text(
                      'Welcome to Tab Settle',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(onPressed: (){},
                    icon: Icon(Icons.receipt_long),
                    label:
                Text
                  ('Sapore')),
              ),

              SizedBox(
                width: buttonWidth,
                child: ElevatedButton.icon(onPressed: (){},
                    icon: Icon(Icons.receipt_long),
                    label:
                    Text
                      ('Toby Carvery')),
              ),

            ],
          ),
        )
      )


    );
  }
}
