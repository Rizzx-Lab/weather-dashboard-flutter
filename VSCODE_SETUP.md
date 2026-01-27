# 💻 Setup VS Code untuk Flutter Development

## 🎯 Overview

VS Code adalah IDE yang **RECOMMENDED** untuk Flutter development karena:
- ✅ Ringan dan cepat
- ✅ Extensions Flutter/Dart official dari Google
- ✅ Hot reload super cepat
- ✅ Debugging yang powerful
- ✅ Gratis dan open source

## 📥 Step 1: Install VS Code

### Windows
1. Download dari: https://code.visualstudio.com/
2. Run installer
3. Centang: "Add to PATH" saat install

### macOS
```bash
brew install --cask visual-studio-code
```

### Linux
```bash
# Ubuntu/Debian
sudo snap install code --classic

# Arch
yay -S visual-studio-code-bin
```

## 🔌 Step 2: Install Extensions

Buka VS Code, tekan `Ctrl+Shift+X` (Windows/Linux) atau `Cmd+Shift+X` (Mac), cari dan install:

### 1️⃣ **Flutter** (WAJIB)
- Publisher: Dart Code
- Features: Syntax highlight, debugging, hot reload
- Install command: `code --install-extension Dart-Code.flutter`

### 2️⃣ **Dart** (WAJIB)
- Publisher: Dart Code
- Otomatis terinstall dengan Flutter extension

### 3️⃣ **Awesome Flutter Snippets** (Recommended)
- Quick code snippets
- Install: Search "Awesome Flutter Snippets" di Extensions

### 4️⃣ **Bracket Pair Colorizer 2** (Optional)
- Colorize bracket pairs
- Memudahkan membaca nested widgets

### 5️⃣ **Error Lens** (Optional)
- Show errors inline
- Membantu debug lebih cepat

### 6️⃣ **Material Icon Theme** (Optional)
- Better file icons
- Estetik saja

## ⚙️ Step 3: Configure VS Code

### Buat file `.vscode/settings.json` di project:

```json
{
  "dart.flutterSdkPath": "path/to/flutter/sdk",
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.rulers": [80],
  "dart.debugExternalPackageLibraries": false,
  "dart.debugSdkLibraries": false,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": false
  }
}
```

### Buat file `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    },
    {
      "name": "Flutter (Profile Mode)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "flutterMode": "profile"
    }
  ]
}
```

## 🎮 Step 4: Keyboard Shortcuts

### Essential Shortcuts:

| Shortcut | Action | Keterangan |
|----------|--------|------------|
| `Ctrl+Shift+P` / `Cmd+Shift+P` | Command Palette | Akses semua commands |
| `F5` | Start Debugging | Run app dengan debug |
| `Ctrl+F5` | Run Without Debugging | Run tanpa debug |
| `Shift+F5` | Stop Debugging | Stop app |
| `Ctrl+\`` | Toggle Terminal | Buka/tutup terminal |
| `r` | Hot Reload | Reload UI (di terminal) |
| `R` | Hot Restart | Restart app (di terminal) |
| `p` | Show performance overlay | Debug performance |
| `Ctrl+Space` | Trigger suggestions | Autocomplete |
| `Shift+Alt+F` | Format Document | Format code |

### Flutter-specific:

- `stless` → Create StatelessWidget
- `stful` → Create StatefulWidget
- `Ctrl+.` → Quick Fix / Refactor

## 📱 Step 5: Setup Device

### Android Emulator:

1. **Install Android Studio** (hanya untuk tools, tidak perlu dibuka)
2. **Open VS Code Command Palette** (`Ctrl+Shift+P`)
3. Type: "Flutter: Launch Emulator"
4. Pilih emulator atau create new

### iOS Simulator (Mac only):

1. Command Palette → "Flutter: Launch Simulator"
2. Otomatis buka iOS Simulator

### Physical Device:

**Android:**
1. Enable Developer Mode di HP
2. Enable USB Debugging
3. Connect via USB
4. Trust computer
5. Device akan muncul di VS Code

**iOS:**
1. Trust computer di iPhone
2. Open in Xcode once
3. Device akan muncul

## 🚀 Step 6: Run Project

### Method 1: Via UI
1. Open project folder di VS Code
2. Pilih device di bottom-right corner
3. Tekan `F5` atau klik "Run" → "Start Debugging"

### Method 2: Via Terminal
```bash
# Open terminal di VS Code (Ctrl+`)
flutter pub get  # Install dependencies
flutter run      # Run app
```

### Method 3: Via Command Palette
1. `Ctrl+Shift+P`
2. Type: "Flutter: Run Flutter App"
3. Enter

## 🐛 Debugging di VS Code

### 1. Breakpoints
- Klik di sebelah kiri line number
- Atau tekan `F9` di line yang mau di-debug

### 2. Debug Console
- Lihat output di "Debug Console" tab
- Bisa execute Dart code langsung

### 3. Variables
- Lihat state variables di sidebar kiri saat debugging
- Expand objects untuk lihat properties

### 4. Call Stack
- Lihat function call stack
- Navigate ke function calls

### 5. Watch Expressions
- Add expressions untuk di-watch
- Berguna untuk monitor state changes

## 🔍 Tips & Tricks

### 1. Widget Inspector
```bash
# Buka Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools
```
- Klik "Flutter Inspector" di DevTools
- Inspect widget tree secara visual
- Debug layout issues

### 2. Quick Fixes
- Hover over error/warning
- Klik light bulb 💡 atau tekan `Ctrl+.`
- Pilih quick fix yang sesuai

### 3. Extract Widget
```dart
// Select widget code
// Ctrl+. → Extract Widget
// Beri nama widget baru
```

### 4. Wrap with Widget
```dart
// Cursor di widget
// Ctrl+. → Wrap with Container/Column/etc
```

### 5. Format on Save
Sudah di-enable di settings.json, tapi bisa manual:
- `Shift+Alt+F` untuk format document
- `Ctrl+K Ctrl+F` untuk format selection

### 6. Multi-cursor
- `Alt+Click` untuk tambah cursor
- `Ctrl+Alt+↑/↓` untuk multi-line cursor
- Berguna untuk edit multiple lines

### 7. Go to Definition
- `F12` untuk jump ke definition
- `Alt+F12` untuk peek definition
- `Shift+F12` untuk find all references

## 🎨 Customize Theme

### Recommended Themes untuk Flutter:
1. **Dracula Official**
2. **One Dark Pro**
3. **Material Theme**
4. **Night Owl**

Install via Extensions, lalu:
```bash
Ctrl+Shift+P → "Preferences: Color Theme"
```

## ⚡ Performance Tips

### 1. Disable Extensions yang Tidak Perlu
- Extensions bisa bikin VS Code lemot
- Disable extensions yang tidak relevan

### 2. Exclude Folders dari Search
Di settings.json:
```json
{
  "files.exclude": {
    "**/.dart_tool": true,
    "**/.packages": true,
    "**/build": true
  },
  "search.exclude": {
    "**/build": true,
    "**/.dart_tool": true
  }
}
```

### 3. Increase Memory Limit
Tambahkan ke settings:
```json
{
  "dart.analysisServerMaxOldSpaceSize": 4096
}
```

## 🆘 Troubleshooting

### "Flutter SDK not found"
```bash
# Set path manually
Ctrl+Shift+P → "Flutter: Change SDK"
# Pilih folder flutter/bin
```

### "Dart Analysis Server taking too long"
```bash
# Restart analysis server
Ctrl+Shift+P → "Dart: Restart Analysis Server"
```

### Hot Reload tidak jalan
```bash
# Di terminal VS Code
r  # Try hot reload
R  # Try hot restart
q  # Quit and restart app
```

### Extensions error
```bash
# Reload VS Code
Ctrl+Shift+P → "Developer: Reload Window"
```

## 📚 Useful Commands

```bash
# Command Palette (Ctrl+Shift+P), ketik:

Flutter: New Project              # Buat project baru
Flutter: Run Flutter Doctor       # Cek Flutter setup
Flutter: Clean Project            # Clean build files
Flutter: Get Packages             # Install dependencies
Flutter: Upgrade Packages         # Update dependencies
Flutter: Open DevTools            # Buka Flutter DevTools
Flutter: Change SDK               # Ganti Flutter SDK path
Dart: Restart Analysis Server     # Restart Dart analyzer
```

## 🎓 Learning Resources

- [VS Code Flutter Docs](https://flutter.dev/docs/development/tools/vs-code)
- [Dart in VS Code](https://dartcode.org/)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)

---

## ✅ Checklist Setup

- [ ] VS Code installed
- [ ] Flutter extension installed
- [ ] Dart extension installed
- [ ] settings.json configured
- [ ] launch.json created
- [ ] Device/emulator connected
- [ ] Can run `flutter doctor` successfully
- [ ] Can hot reload (test with `r`)
- [ ] Debugging works (test with breakpoint)

Jika semua ✅, kamu siap untuk Flutter development! 🚀

---

**Happy Coding! 💙**
