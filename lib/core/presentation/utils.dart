import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loggy/loggy.dart';

PreferredSizeWidget createAppBar(BuildContext context, Widget? header) {
  return AppBar(
    title: header,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      // Or Icons.arrow_back_ios for iOS style
      onPressed: () {
        logDebug('can pop is ${context.canPop()}');
        // Cleans up the stack and takes the user back
        if (context.canPop()) {
          context.pop();
        }
      },
    ),
    toolbarHeight: 120.0,
    centerTitle: true,
    // elevation: 1.0,
    // primary: true,
    // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [],
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
