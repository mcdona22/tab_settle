import 'package:flutter/material.dart';

class CustomErrorView extends StatelessWidget {
  const CustomErrorView({
    super.key,
    required this.title,
    this.description = '',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: theme.colorScheme.error),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12.0),
          title: Text(title, style: theme.textTheme.titleLarge),
          subtitle: description.isNotEmpty
              ? Text(description, style: theme.textTheme.titleMedium)
              : SizedBox.shrink(),
          leading: Icon(
            Icons.error,
            size: 48.0,
            color: theme.colorScheme.error,
          ),
        ),
      ),
    );
  }
}
