class LexoRankException implements Exception {
  const LexoRankException(this.message);

  final String message;

  @override
  String toString() => 'LexoRankException: $message';
}
