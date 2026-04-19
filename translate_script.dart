import 'dart:io';
import 'dart:convert';

void main() async {
  final arbFile = File('packages/pj_l10n/lib/l10n/app_en.arb');
  final arbContent = await arbFile.readAsString();
  
  // Strip single-line comments // ...
  final jsonString = arbContent.replaceAll(RegExp(r'^\s*//.*$', multiLine: true), '');
  
  final Map<String, dynamic> arbMap = jsonDecode(jsonString);
  
  final translations = <String, String>{}; // map from English string -> arb key
  arbMap.forEach((key, value) {
    if (!key.startsWith('@') && value is String && !value.contains('{')) {
      translations[value] = key;
    }
  });

  print('Loaded ${translations.length} translations.');

  final dirs = ['pj_admin/lib', 'pj_customer/lib', 'pj_driver/lib', 'pj_staff/lib'];
  int totalChanges = 0;

  for (final dir in dirs) {
    final d = Directory(dir);
    if (!d.existsSync()) continue;

    await for (final entity in d.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        String content = await entity.readAsString();
        bool changed = false;

        for (final entry in translations.entries) {
          final englishStr = entry.key;
          final l10nKey = entry.value;

          // e.g. Text('Dashboard') or Text("Dashboard")
          final q1 = "'$englishStr'";
          final q2 = '"$englishStr"';
          
          final textPattern = "Text($q1)";
          final textPattern2 = "Text($q2)";
          final newText = "Text(L10n.of(context)!.$l10nKey)";

          if (content.contains(textPattern)) {
            content = content.replaceAll("const $textPattern", newText);
            content = content.replaceAll("const  $textPattern", newText);
            content = content.replaceAll(textPattern, newText);
            changed = true;
          }
          if (content.contains(textPattern2)) {
            content = content.replaceAll("const $textPattern2", newText);
            content = content.replaceAll(textPattern2, newText);
            changed = true;
          }
          
          // Also handle simple strings like title: 'LTMS' -> title: L10n.of(context)!.appTitle
          // We can just replace literal matches like:
          // Text('String', ...)
          final textPatternComma1 = "Text($q1,";
          final textPatternComma2 = "Text($q2,";
          final newTextComma = "Text(L10n.of(context)!.$l10nKey,";
          if (content.contains(textPatternComma1)) {
            content = content.replaceAll("const $textPatternComma1", newTextComma);
            content = content.replaceAll(textPatternComma1, newTextComma);
            changed = true;
          }
          if (content.contains(textPatternComma2)) {
            content = content.replaceAll("const $textPatternComma2", newTextComma);
            content = content.replaceAll(textPatternComma2, newTextComma);
            changed = true;
          }

          // Handle TextButton.icon label: const Text(...)
          final labelPattern1 = "label: const Text($q1)";
          final labelPattern2 = "label: const Text($q1,";
          final newLabel1 = "label: Text(L10n.of(context)!.$l10nKey)";
          final newLabel2 = "label: Text(L10n.of(context)!.$l10nKey,";

          if (content.contains(labelPattern1)) {
            content = content.replaceAll(labelPattern1, newLabel1);
            changed = true;
          }
          if (content.contains(labelPattern2)) {
            content = content.replaceAll(labelPattern2, newLabel2);
            changed = true;
          }
        }

        if (changed) {
          // Add L10n import if needed
          if (!content.contains("import 'package:pj_l10n/pj_l10n.dart';")) {
            // Find a good spot to insert
            final match = RegExp(r'import .*;').allMatches(content).last;
            content = content.substring(0, match.end) + "\nimport 'package:pj_l10n/pj_l10n.dart';" + content.substring(match.end);
          }
          await entity.writeAsString(content);
          totalChanges++;
        }
      }
    }
  }
  print('Changed $totalChanges files.');
}
