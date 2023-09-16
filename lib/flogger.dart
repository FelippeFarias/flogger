library flogger;

import 'dart:developer' as developer;
import 'dart:isolate';

class Flogger {
  static const String _TOP_LINE =
      "┌────────────────────────────────────────────────────────────────────────────────────────";
  static const String _MIDDLE_LINE =
      "├────────────────────────────────────────────────────────────────────────────────────────";
  static const String _BOTTOM_LINE =
      "└────────────────────────────────────────────────────────────────────────────────────────";
  static const String _VERTICAL_DOUBLE_LINE = "│";
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
      _log(FloggerLevel.info, obj.toString(), tag: tag);
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

  static void _log(FloggerLevel level, String msg,
      {String? tag, StackTrace? stackTrace}) {
    stackTrace ??= StackTrace.current;
    final callerInfo = _extractCallerInformation(stackTrace);
    var logMessage = [
      " ",
      _TOP_LINE,
      "$_VERTICAL_DOUBLE_LINE Thread: ${Isolate.current.debugName}, Source:$callerInfo",
      _MIDDLE_LINE,
      "$_VERTICAL_DOUBLE_LINE ${msg.toString().split("\n").join("\n$_VERTICAL_DOUBLE_LINE")}",
      _BOTTOM_LINE,
    ].join("\n");

    _handlePrintMessage(level, logMessage, _handleTag(tag));
  }
}

void _handlePrintMessage(FloggerLevel level, String msg, String tag) {
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

String _extractCallerInformation(StackTrace stackTrace) {
  final stackList = stackTrace.toString().split('\n');
  for (String stack in stackList) {
    if (!stack.contains('Flogger.')) {
      return stack.trim(); // Remove espaços em branco
    }
  }
  return "Unknown source";
}

enum FloggerLevel {
  debug,
  info,
  error,
  warning,
}
