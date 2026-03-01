/// Single entry point for all integration tests.
///
/// Flutter on Windows cannot launch a second app process mid-run, so
/// `flutter test integration_test/ -d windows` fails when multiple test
/// files exist.  Running this file instead keeps everything inside one
/// process.
///
/// Each file is wrapped in a `group()` to scope its setUp/tearDown so they
/// don't bleed into the other file's tests.
///
/// Usage:
///   flutter test integration_test/all_tests.dart -d windows
library;
// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter_test/flutter_test.dart';

import 'create_verb_flow_test.dart' as create_verb_flow;
import 'session_settings_flow_test.dart' as session_settings_flow;
import 'word_list_quick_practice_test.dart' as word_list_quick_practice;

void main() {
  group('create_verb_flow_test', create_verb_flow.main);
  group('session_settings_flow_test', session_settings_flow.main);
  group('word_list_quick_practice_test', word_list_quick_practice.main);
}
