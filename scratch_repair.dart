import 'dart:io';

void main() {
  final files = [
    'lib/screens/settings_screen.dart',
    'lib/screens/post_creation_screen.dart',
    'lib/screens/main_screen.dart'
  ];

  for (final filepath in files) {
    final file = File(filepath);
    var content = file.readAsStringSync();
    
    // Fix the literal $1
    content = content.replaceAll(r'$1(LucideIcons', r'Icon(LucideIcons');
    content = content.replaceAll(r'$1(color', r'BorderSide(color');
    content = content.replaceAll(r'$1(fontSize', r'TextStyle(fontSize');
    content = content.replaceAll(r'$1(color: AppColors.pink50, shape: BoxShape.circle)', r'BoxDecoration(color: AppColors.pink50, shape: BoxShape.circle)');
    
    file.writeAsStringSync(content);
  }
  print("Done repairing");
}
