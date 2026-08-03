import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/core/extensions/map.extensions.dart';
import 'package:tab_settle/features/bill_analyse/service/gemini_service.dart';

part 'bill_submission_controller.g.dart';

@Riverpod(keepAlive: false)
class BillSubmissionController extends _$BillSubmissionController with UiLoggy {
  @override
  FutureOr<Map<String, dynamic>> build() {
    return {};
  }

  // Future<void> analyseReceipt() async {
  //   state = const AsyncValue.loading();
  //   loggy.debug('Analysing ...');
  //
  //   await Future.delayed(Duration(seconds: 3));
  //   loggy.debug('wait complete');
  //
  //   final text = await ref.read(geminiServiceProvider).fetchGreeting();
  //   loggy.debug('api invocation complete: "$text"');
  //
  //   state = AsyncData(text);
  // }

  Future<void> analyseTextReceipt(String textReceipt) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final geminiService = ref.read(geminiServiceProvider);
      final analysedReceipt = await geminiService.analyseTextReceipt(
        textReceipt,
      );
      loggy.debug(analysedReceipt.toPrettyJson);
      return analysedReceipt;
    });
  }
}
