import 'package:flutter/material.dart';

class IntroPageView extends StatelessWidget {
  const IntroPageView({
    required this.controller,
    required this.assetImageFileName,
    required this.text,
    this.title,
    super.key,
  });

  final List<String> text;
  final String assetImageFileName;
  final String? title;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/graphics/$assetImageFileName';
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(flex: 7, child: Image.asset(imagePath, fit: BoxFit.contain)),

        // const Divider(height: 1.0, indent: 12.0, endIndent: 12.0),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 12.0,
                children: text
                    .map((line) => Text(line, style: textTheme.bodyLarge))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
