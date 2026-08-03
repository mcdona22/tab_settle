import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/service/receipt_schema_provider.dart';

part 'generative_model_provider.g.dart';

const geminiKey = 'AQ.Ab8RN6J7ZXCc3D8OkscW8E9JIck9qj4LBNO4BtvcrnB6-DSD2Q';
const modelVersion = 'gemini-3.6-flash';

@Riverpod(keepAlive: true)
GenerativeModel receiptGenerativeModel(Ref ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  final schema = ref.watch(receiptSchemaProvider);

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

final geminiApiKeyProvider = Provider<String>((_) => geminiKey);
