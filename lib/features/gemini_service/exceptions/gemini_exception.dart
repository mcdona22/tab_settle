import 'package:tab_settle/features/gemini_service/exceptions/gemini_exception_kind.dart';

abstract class GeminiException implements Exception {
  final GeminiErrorKind kind;
  final Object? cause;

  const GeminiException(this.kind, [this.cause]);

  @override
  String toString() => 'GeminiException{ ${kind.title} : ${kind.description}';
}

class GeminiServiceOverloadException extends GeminiException {
  const GeminiServiceOverloadException([Object? cause])
    : super(GeminiErrorKind.overloaded, cause);
}

class GeminiNetworkException extends GeminiException {
  const GeminiNetworkException([Object? cause])
    : super(GeminiErrorKind.networkSlow, cause);
}

class GeminiOfflineException extends GeminiException {
  const GeminiOfflineException([Object? cause])
    : super(GeminiErrorKind.networkOffline, cause);
}

class GeminiUnknownException extends GeminiException {
  const GeminiUnknownException([Object? cause])
    : super(GeminiErrorKind.unknown, cause);
}
