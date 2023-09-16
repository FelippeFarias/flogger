library flogger;

import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';

class Flogger {
  static int _MAX_WIDTH = 150;
  static bool isLoggingEnabled = true;
  static String globalLogTag = " FloggerLogs";

  static void d(Object? obj, {String? tag}) {
    if (Flogger.isLoggingEnabled) {
      _log(FloggerLevel.debug, obj.toString(), tag: tag);
    }
  }

  static void e(Object? obj, {String? tag}) {
    if (Flogger.isLoggingEnabled) {
      _log(FloggerLevel.error, obj.toString(), tag: tag);
    }
  }

  static void i(Object? obj, {String? tag}) {
    if (Flogger.isLoggingEnabled) {
      _log(FloggerLevel.info, obj.toString(), tag: tag);
    }
  }

  static void w(Object? obj, {String? tag}) {
    if (Flogger.isLoggingEnabled) {
      _log(FloggerLevel.warning, obj.toString(), tag: tag);
    }
  }

  static void v(Object? obj, {String? tag}) {
    if (Flogger.isLoggingEnabled) {
      _log(FloggerLevel.info, obj.toString(), tag: tag);
    }
  }

  static String _handleTag(String? customTag) {
    if (customTag != null && customTag.isNotEmpty) {
      return customTag;
    } else if (Flogger.globalLogTag.isNotEmpty) {
      return Flogger.globalLogTag;
    } else {
      return 'L';
    }
  }

  static void _log(FloggerLevel level, String msg, {String? tag, StackTrace? stackTrace}) {
    stackTrace ??= StackTrace.current;
    final callerInfo = _extractCallerInformation(stackTrace);
    final threadInfo = "Thread: ${Isolate.current.debugName}, Source: $callerInfo";

    List<String> contentLines = msg.split("\n").expand((line) => splitLongLines(line, _MAX_WIDTH)).toList();

    List<String> allLines = [
      threadInfo,
      ...contentLines
    ];

    int maxWidth = allLines.fold(0, (int currentMax, line) => currentMax > line.length ? currentMax : line.length);

    // Constrói as linhas da caixa com base nessa largura
    final topLine = "╔" + "═" * maxWidth + "╗";
    final middleLine = "╟" + "─" * maxWidth + "╢";
    final bottomLine = "╚" + "═" * maxWidth + "╝";

    // Cria a mensagem formatada
    var logMessage = [
      topLine,
      "║" + threadInfo.padRight(maxWidth) + "║",
      middleLine,
      ...contentLines.map((line) => "║" + line.padRight(maxWidth) + "║"),
      bottomLine,
    ].join("\n");

    _handlePrintMessage(level, "\n${logMessage}\n", _handleTag(tag));
  }

  static List<String> splitLongLines(String line, int maxWidth) {
    List<String> lines = [];
    while (line.length > maxWidth) {
      lines.add(line.substring(0, maxWidth));
      line = line.substring(maxWidth);
    }
    lines.add(line);
    return lines;
  }

  static void _handlePrintMessage(FloggerLevel level, String msg, String tag) {
    switch (level) {
      case FloggerLevel.debug:
        developer.log(
          msg,
          name: '🐛 [DEBUG]: $tag',
          time: DateTime.now(),
        );
        break;
      case FloggerLevel.info:
        print('✨ [INFO]: $tag:$msg');
        break;
      case FloggerLevel.error:
        developer.log(
          '',
          name: '❌ [ERROR]: $tag',
          time: DateTime.now(),
          error: msg,
        );
        break;

      case FloggerLevel.warning:
        developer.log(
          '',
          name: '⚠️ [WARNING]: $tag',
          time: DateTime.now(),
          error: msg,
        );
        break;
    }
  }

  static String _extractCallerInformation(StackTrace stackTrace) {
    final stackList = stackTrace.toString().split('\n');
    for (String stack in stackList) {
      if (!stack.contains('Flogger.')) {
        return stack.trim(); // Remove espaços em branco
      }
    }
    return "Unknown source";
  }
}

enum FloggerLevel {
  debug,
  info,
  error,
  warning,
}
