import 'dart:io';
void main() {
  for (var lang in ['en', 'ku']) {
    var f = File('packages/pj_l10n/lib/l10n/app_$lang.arb');
    if (!f.existsSync()) continue;
    var raw = f.readAsStringSync();
    raw = raw.replaceAll(RegExp(r'^\s*//.*$', multiLine: true), '');
    f.writeAsStringSync(raw);
  }
}
