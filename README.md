# Flogger Dart Library

## Description

Flogger is a simple yet powerful logging library for Dart applications. It supports various logging levels, such as debug, info, warning, and error, and provides beautifully formatted console output. This library is ideal for those who wish to keep track of activities within their application, find bugs, or monitor app performance.

## Features

- Supports logging for debug, info, warning, and error levels.
- Thread and source caller information.
- Predefined log message templates with customizable tags.
- Global toggling of log status.
- Utilizes Dart's developer logging capabilities.

## Installation

To include this package in your Dart project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  flogger: ^latest_version
```

Then run `pub get`.

## Usage

First, import the package in your Dart code:

```dart
import 'package:flogger/flogger.dart';
```

Here are a few ways to use the library:

### Debug Log

```dart
Flogger.d(DateTime.now());
/*
[🐛 [DEBUG]:  FloggerTag]
╔═════════════════════════════════════════════════════════════════════════════════════╗
║Thread: main, Source: #2      ExampleController.chooseDate (example/main.dart:13:13)║
╟─────────────────────────────────────────────────────────────────────────────────────╢
║2023-09-16 23:43:16.678749                                                           ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
*/
```

### Warning Log with Custom Tag

```dart
Flogger.w("Warning message", tag: "WarningTag");
/*
[️ [WARNING]: WarningTag]
╔═════════════════════════════════════════════════════════════════════════════════════╗
║Thread: main, Source: #2      ExampleController.clickButton (example/main.dart:16:18)║
╟─────────────────────────────────────────────────────────────────────────────────────╢
║ Warning message                                                      ║
╚═════════════════════════════════════════════════════════════════════════════════════╝
*/
```

### Error Log

```dart
Flogger.e({"error":"msg error" , "status": 404});
/*
[❌ [ERROR]:  FloggerLogs]
╔═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║Thread: main, Source: #2      ExampleController.requestServer (example/main.dart:13:13)║
╟─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╢
║{error: msg error, status: 404}                                                                                                      ║
╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
*/
```

## API

### Global Configurations

- `isLoggingEnabled`: Boolean to enable or disable logging globally.
- `globalLogTag`: A string used as the global tag for the log if no tag is specified in the individual log methods.

### Methods

- `d(Object? obj, {String? tag})`: Logs a debug message.
- `i(Object? obj, {String? tag})`: Logs an info message.
- `w(Object? obj, {String? tag})`: Logs a warning message.
- `e(Object? obj, {String? tag})`: Logs an error message.

### Internal Methods (not intended for public use)

- `_log(FloggerLevel level, String msg, {String? tag, StackTrace? stackTrace})`: Main logging method which decides how the message is logged based on the log level.
- `_handlePrintMessage(FloggerLevel level, String msg, String tag)`: Handles how the log messages are printed to the console.
- `_extractCallerInformation(StackTrace stackTrace)`: Extracts the caller's information from the stack trace.

## Contributions

Contributions, issues, and feature requests are welcome!

## License

This project is licensed under the MIT License.