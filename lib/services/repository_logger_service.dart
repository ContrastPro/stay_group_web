import 'package:logger/logger.dart';

class RepositoryLogger {
  const RepositoryLogger({
    required this.repositoryName,
  });

  final String repositoryName;

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      colors: false,
      printEmojis: false,
      methodCount: 0,
      errorMethodCount: 3,
      lineLength: 120,
    ),
  );

  void log(String? message, {String? name}) {
    _logger.i(
      message,
      error: '$repositoryName: $name',
    );
  }
}
