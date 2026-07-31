import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/centred_constrained_widget.dart';
import 'package:tab_settle/core/presentation/utils.dart';

class BillSubmissionPage extends HookConsumerWidget
    with UiLoggy {
  const BillSubmissionPage({
    required this.imageName,
    super.key,
  });

  final String imageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qualifiedPath = 'assets/test_receipts/$imageName';
    return Scaffold(
      appBar: createAppBar(context, 'Submit Receipt'),
      body: CentredConstrainedWidget(
        child: Padding(
          padding: EdgeInsetsGeometry.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    qualifiedPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 48,
                            color: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          Text(
                            'Unable to load $qualifiedPath',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
