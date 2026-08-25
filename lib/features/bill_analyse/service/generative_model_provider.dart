import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/service/receipt_schema_provider.dart';

part 'generative_model_provider.g.dart';

const modelVersion = 'gemini-3.5-flash-lite';

typedef GenerativeModelHandle = ({GenerativeModel model, http.Client client});

@Riverpod(keepAlive: true)
GenerativeModel Function(http.Client client) receiptModelBuilder(Ref ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  final schema = ref.watch(receiptSchemaProvider);
  return (http.Client client) {
    return GenerativeModel(
      model: modelVersion,
      apiKey: apiKey,
      httpClient: client,
      requestOptions: const RequestOptions(),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
        temperature: 0.0,
      ),
    );
  };
}

@riverpod
GenerativeModelHandle receiptGenerativeModelHandle(Ref ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  final schema = ref.watch(receiptSchemaProvider);
  logDebug('receiptGenerativeModelProvider: using modelVersion $modelVersion');
  final httpClient = http.Client();

  ref.onDispose(() {
    logDebug('The model is closing its http client');
    httpClient.close();
  });

  final model = GenerativeModel(
    model: modelVersion,
    apiKey: apiKey,
    requestOptions: const RequestOptions(),
    httpClient: httpClient,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: schema,
      temperature: 0.0,
    ),
  );

  return (model: model, client: httpClient);
}

final geminiApiKeyProvider = Provider<String>((_) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  logDebug('geminiApiKeyProvider: api key found is ${apiKey.isNotEmpty}');
  return apiKey;
});
