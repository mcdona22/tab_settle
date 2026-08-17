import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tab_settle/core/routing/router.dart';

PreferredSizeWidget createAppBar(BuildContext context, Widget? header) {
  final isHome = GoRouterState.of(context).matchedLocation == '/';
  return AppBar(
    title: header,
    leading: context.canPop()
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            // Or Icons.arrow_back_ios for iOS style
            onPressed: () {
              // Cleans up the stack and takes the user back
              if (context.canPop()) {
                context.pop();
              }
            },
          )
        : null,
    toolbarHeight: 120.0,
    centerTitle: true,
    // elevation: 1.0,
    // primary: true,
    // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [
      if (!isHome)
        IconButton(
          onPressed: () => context.goNamed(AppRoute.home.name),
          icon: Icon(Icons.home),
        ),
    ],
  );
}

Image? crossPlatformPathImage(String path, {BoxFit fit = BoxFit.contain}) {
  if (path.isEmpty) return null;

  return kIsWeb
      ? Image.network(path, fit: fit)
      : Image.file(File(path), fit: fit);
}

BoxDecoration correctionOutline(BuildContext context) => BoxDecoration(
  // color: Theme.of(context).colorScheme.secondary.withAlpha(30),
  borderRadius: BorderRadius.circular(8.0),
  border: Border.all(
    color: Theme.of(context).colorScheme.secondary.withAlpha(90),
    width: 1.0,
  ),
);
