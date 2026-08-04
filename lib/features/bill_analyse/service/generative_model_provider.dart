import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/service/receipt_schema_provider.dart';

part 'generative_model_provider.g.dart';

const modelVersion = 'gemini-3.5-flash-lite';

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
