import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


PreferredSizeWidget createAppBar(
    BuildContext context,
    String title,
    ) {
  return AppBar(
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      // Or Icons.arrow_back_ios for iOS style
      onPressed: () {
        // Cleans up the stack and takes the user back
        if (context.canPop()) {
          context.pop();
        }
      },
    ),
    toolbarHeight: 120.0,
    centerTitle: true,
    elevation: 1.0,
    // primary: true,
    backgroundColor: Theme.of(
      context,
    ).colorScheme.inversePrimary,
    actions: [],
  );
}