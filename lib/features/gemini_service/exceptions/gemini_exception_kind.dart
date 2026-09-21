enum GeminiErrorKind {
  overloaded(
    title: 'Analysis Service Busy',
    description: 'The service is experiencing heavy traffic',
    isRetryable: true,
  ),
  unknown(
    title: 'Analysis Failed',
    description:
        'We could not process this receipt right now. Please try again.',
    isRetryable: true,
  ),
  networkSlow(
    title: 'Internet Connection Issue',
    description: "Your internet connection appears too slow",
    isRetryable: true,
  );

  const GeminiErrorKind({
    required this.title,
    required this.description,
    required this.isRetryable,
  });

  final String title;
  final String description;
  final bool isRetryable;
}
