abstract class AppConfig {
  static const String version = '1.0.0+2: Defeat Caching'; // Version + Build
  // Number
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'https://gemini-proxy-566341541330.europe-west2.run.app/api/v1',
  );
}
