import 'dart:io';

void main() {
  final files = [
    'lib/screens/settings_screen.dart',
    'lib/screens/post_creation_screen.dart',
    'lib/screens/main_screen.dart'
  ];

  for (final filepath in files) {
    final file = File(filepath);
    final content = file.readAsStringSync();
    
    final lines = content.split('\n');
    final newLines = <String>[];
    for (var line in lines) {
      if (line.contains('AppColors.pink')) {
        line = line.replaceAll(RegExp(r'const\s+(Icon|BorderSide|BoxDecoration|TextStyle)'), r'$1');
      }
      newLines.add(line);
    }
    
    file.writeAsStringSync(newLines.join('\n'));
  }
  print("Done");
}
