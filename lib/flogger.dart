library flogger;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:isolate';

class Flogger {
  static const String TOP_LINE =
      "┌────────────────────────────────────────────────────────────────────────────────────────";
  static const String MIDDLE_LINE =
      "├────────────────────────────────────────────────────────────────────────────────────────";
  static const String BOTTOM_LINE =
      "└────────────────────────────────────────────────────────────────────────────────────────";
  static const String VERTICAL_DOUBLE_LINE = "│";
  static bool isLoggingEnabled = true;
  static String globalLogTag = " FloggerLogs";

  static void d(Object? obj, {String? tag, StackTrace? stackTrace}) {
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

  static String _formatJson(Object? json) {
    try {
      if (json is Map || json is List) {
        return JsonEncoder.withIndent('  ').convert(json);
      } else {
        return json.toString();
      }
    } catch (e) {
      e.toString();
      return "An Error While Printing This Json: $e";
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
      TOP_LINE,
      "$VERTICAL_DOUBLE_LINE Thread: ${Isolate.current.debugName}, Source:$callerInfo",
      MIDDLE_LINE,
      "$VERTICAL_DOUBLE_LINE ${msg.toString().split("\n").join("\n$VERTICAL_DOUBLE_LINE")}",
      BOTTOM_LINE,
    ].join("\n");

    _handlePrintMessage(level, logMessage, _handleTag(tag));
  }
}

void _handlePrintMessage(FloggerLevel level, String msg, String tag) {
  switch (level) {
    case FloggerLevel.debug:
      developer.log(
        msg,
        name: '🐛 [DEBUG]: ${tag}',
        time: DateTime.now(),
      );
      break;
    case FloggerLevel.info:
      print('✨ [INFO]: ${tag}:${msg}');
      break;
    case FloggerLevel.error:
      developer.log(
        '',
        name: '❌ [ERROR]: ${tag}',
        time: DateTime.now(),
        error: msg,
      );
      break;

    case FloggerLevel.warning:
      developer.log(
        '',
        name: '⚠️ [WARNING]: ${tag}',
        time: DateTime.now(),
        error: msg,
      );
      break;
  }
}

String _extractCallerInformation(StackTrace stackTrace) {
  final current = stackTrace.toString().split('\n');

  for (int i = 0; i < current.length; i++) {
    if (current[i].contains('package:flog_utils') &&
        !current[i].contains('L.dart')) {
      return current[i].trim();
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
