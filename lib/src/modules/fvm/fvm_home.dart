import 'dart:async';
import 'dart:io';

/// Resolves the `FVM_HOME` the user configured in their shell.
///
/// Apps launched from Finder/the dock don't inherit the variables exported
/// in shell profiles (`.zshrc`, `.zshenv`, ...), so a custom `FVM_HOME` is
/// ignored and Sidekick falls back to `~/fvm`. Returns `null` when the
/// variable is already visible, unset, or can't be resolved.
Future<String?> resolveShellFvmHome() async {
  if (Platform.isWindows) return null;
  if (Platform.environment['FVM_HOME']?.isNotEmpty ?? false) return null;

  final shell = Platform.environment['SHELL'] ?? '/bin/zsh';

  try {
    // Interactive login shell so it loads the same files as a terminal
    final result = await Process.run(
      shell,
      ['-ilc', r'printf %s "$FVM_HOME"'],
    ).timeout(const Duration(seconds: 5));

    if (result.exitCode != 0) return null;

    // Profiles can print banners, the value is whatever comes last
    final lines = (result.stdout as String).trim().split('\n');
    final home = lines.isEmpty ? '' : lines.last.trim();

    return home.isEmpty ? null : home;
  } on Exception {
    return null;
  }
}
