import re
import os

files = [
    'lib/screens/settings_screen.dart',
    'lib/screens/post_creation_screen.dart',
    'lib/screens/main_screen.dart'
]

for filepath in files:
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Simple regex replacing `const ` with `` if the same line contains `AppColors.pink`
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if 'AppColors.pink' in line:
            # removing 'const ' before things that have AppColors.pink inside them.
            # actually we can just safely replace 'const ' with '' on lines with AppColors.pink
            # But wait, what if there's another const that needs to remain?
            # It's better to specifically replace 'const Icon', 'const BorderSide', 'const BoxDecoration', 'const TextStyle'
            line = re.sub(r'const\s+(Icon|BorderSide|BoxDecoration|TextStyle)', r'\1', line)
        new_lines.append(line)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write('\n'.join(new_lines))

print("Done")
