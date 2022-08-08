import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  final movieApiKey = const String.fromEnvironment("movieApiKey");
  static const movieApiKeyStatic = String.fromEnvironment("movieApiKey");
}

final environmentConfigProvider = Provider<EnvironmentConfig>((ref) {
  return EnvironmentConfig();
});
