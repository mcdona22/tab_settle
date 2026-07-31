import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeminiService {
  final String _apiKey;

  GeminiService({required String apiKey}) : _apiKey = apiKey;

  Future<String> fetchGreeting() async {
    final model = GenerativeModel(
      model:
          'gemini-1'
          '.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    const prompt =
        'Provide a fresh good morning '
        'salutation in json';

    final response = await model.generateContent([Content.text(prompt)]);
    return response.text ?? '{}';
  }
}

final geminiApiKeyProvider = Provider<String>((_) => 'my key here');

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GeminiService(apiKey: apiKey);
});

final greetingPromptProvider = FutureProvider.autoDispose<String>((ref) async {
  final service = ref.watch(geminiServiceProvider);
  return service.fetchGreeting();
});
