import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/main.dart';
import 'package:toastification/toastification.dart';

part 'feedback_service.g.dart';

@riverpod
FeedbackService feedbackService(_) => FeedbackService();

class FeedbackService with UiLoggy {
  static const showDuration = 3500;

  const FeedbackService();

  BuildContext? get _context => rootNavigatorKey.currentContext;

  void showInfo(String title, {String? description}) {
    _show(
      title: title,
      description: description,
      type: ToastificationType.info,
    );
  }

  void showWarning(String title, {String? description}) {
    _show(
      title: title,
      description: description,
      type: ToastificationType.warning,
    );
  }

  void showError(String title, {String? description}) {
    _show(
      title: title,
      description: description,
      type: ToastificationType.error,
    );
  }

  void showSuccess(String title, {String? description}) {
    _show(
      title: title,
      description: description,
      type: ToastificationType.success,
    );
  }

  void _show({
    required String title,
    String? description,
    required ToastificationType type,
    ToastificationStyle style = ToastificationStyle.minimal,
  }) {
    final textTheme = _context != null ? Theme.of(_context!).textTheme : null;
    final colorScheme = _context != null
        ? Theme.of(_context!).colorScheme
        : null;
    toastification.show(
      type: type,
      style: style,
      title: Text(
        title,
        style: textTheme!.titleLarge?.copyWith(
          color: colorScheme!.onSurfaceVariant,
        ),
      ),
      description: description != null
          ? Text(description, style: textTheme!.titleSmall)
          : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(milliseconds: showDuration),
      animationDuration: Duration(milliseconds: (showDuration / 4).toInt()),
      // showProgressBar: true,
      dragToClose: true,
      backgroundColor: colorScheme!.surfaceContainerLow,
      pauseOnHover: true,
      applyBlurEffect: true,
    );
  }
}
