import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/service/receipt_schema_provider.dart';

part 'generative_model_provider.g.dart';

// const geminiKey = 'AQ.Ab8RN6J7ZXCc3D8OkscW8E9JIck9qj4LBNO4BtvcrnB6-DSD2Q';
// const modelVersion = 'gemini-3.6-flash';
const modelVersion = 'gemini-2.5-flash-lite';

@Riverpod(keepAlive: true)
GenerativeModel receiptGenerativeModel(Ref ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  final schema = ref.watch(receiptSchemaProvider);
  logDebug('receiptGenerativeModelProvider: using modelVersion $modelVersion');

  return GenerativeModel(
    model: modelVersion,
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: schema,
      temperature: 0.0,
    ),
  );
}

final geminiApiKeyProvider = Provider<String>((_) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  logDebug('geminiApiKeyProvider: api key found is ${apiKey.isNotEmpty}');
  return apiKey;
});
