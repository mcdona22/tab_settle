import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/gemini_service/gemini_service.dart';
import 'package:tab_settle/features/gemini_service/i_gemini_service.dart';
import 'package:tab_settle/features/gemini_service/stub_gemini_service.dart'
    hide IGeminiService;

part 'gemini_service_providers.g.dart';

@riverpod
bool useGeminiStub(Ref ref) => true;

@Riverpod(keepAlive: true)
IGeminiService geminiService(Ref ref) => ref.watch(useGeminiStubProvider)
    ? StubGeminiService()
    : GeminiService(ref: ref);
