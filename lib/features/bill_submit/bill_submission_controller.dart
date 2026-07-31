import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bill_submission_controller.g.dart';

@Riverpod(keepAlive: true)
class BillSubmissionController extends _$BillSubmissionController with UiLoggy {
  @override
  FutureOr<String> build() {
    return '';
  }

  Future<void> analyseReceipt() async {
    state = const AsyncValue.loading();
    loggy.debug('Analysing ...');

    await Future.delayed(Duration(seconds: 3));
    loggy.debug('analysis complete');

    state = AsyncData('Message here at ${DateTime.now()}');
  }
}
