# 🚀 Setup Guide - Web Builder

Complete guide to set up and run your Flutter Web builder application.

## 📋 Prerequisites

### Required Software

1. **Flutter SDK** (3.2.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (3.2.0 or higher)
   - Comes with Flutter
   - Verify: `dart --version`

3. **Chrome Browser**
   - Required for Flutter Web development
   - Download from: https://www.google.com/chrome/

4. **VS Code** or **Android Studio** (recommended)
   - VS Code: https://code.visualstudio.com/
   - Install Flutter extension

## 🛠️ Initial Setup

### Step 1: Enable Flutter Web

```bash
flutter config --enable-web
```

### Step 2: Verify Web Support

```bash
flutter devices
```

You should see Chrome listed as an available device.

### Step 3: Get Dependencies

Navigate to the project folder and run:

```bash
cd /path/to/web-builder
flutter pub get
```

This will download all required packages listed in `pubspec.yaml`.

## 🔑 Configure AI Service (Optional)

To enable AI features with Claude API:

1. Get your API key from [Anthropic Console](https://console.anthropic.com/)

2. Create a new file: `lib/config/api_keys.dart`

3. Add your API key:

```dart
class ApiKeys {
  static const String claudeApiKey = 'sk-ant-your-api-key-here';
}
```

4. **Important:** This file is already in `.gitignore` so your key won't be committed.

> **Note:** The app will work without an API key using mock responses for testing.

## ▶️ Running the Application

### Development Mode (Hot Reload)

```bash
flutter run -d chrome
```

This will:
- Build the application
- Launch Chrome
- Enable hot reload (press `r` to reload, `R` for hot restart)

### Development with WebAssembly (Better Performance)

```bash
flutter run -d chrome --wasm
```

### Specific Chrome Profile (Clean State)

```bash
flutter run -d chrome --web-browser-flag="--profile-directory=Default"
```

## 🏗️ Building for Production

### Standard Build

```bash
flutter build web
```

Output will be in `build/web/`

### Build with WebAssembly (Recommended)

```bash
flutter build web --wasm
```

Benefits:
- 30-40% faster startup
- Better performance
- Smaller bundle size

### Build with CanvasKit (Better Graphics)

```bash
flutter build web --web-renderer canvaskit
```

Use for:
- Complex animations
- Custom graphics
- Better text rendering

### Optimized Production Build

```bash
flutter build web --release --wasm --web-renderer canvaskit
```

## 🌐 Deployment Options

### Option 1: Deploy to Netlify

1. Build the app:
   ```bash
   flutter build web --release --wasm
   ```

2. Install Netlify CLI:
   ```bash
   npm install -g netlify-cli
   ```

3. Deploy:
   ```bash
   cd build/web
   netlify deploy --prod
   ```

### Option 2: Deploy to Vercel

1. Build the app:
   ```bash
   flutter build web --release --wasm
   ```

2. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

3. Deploy:
   ```bash
   vercel build/web
   ```

### Option 3: Deploy to Firebase Hosting

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login:
   ```bash
   firebase login
   ```

3. Initialize:
   ```bash
   firebase init hosting
   ```

4. Configure `firebase.json`:
   ```json
   {
     "hosting": {
       "public": "build/web",
       "ignore": [
         "firebase.json",
         "**/.*",
         "**/node_modules/**"
       ],
       "rewrites": [
         {
           "source": "**",
           "destination": "/index.html"
         }
       ]
     }
   }
   ```

5. Deploy:
   ```bash
   flutter build web --release --wasm
   firebase deploy --only hosting
   ```

### Option 4: Deploy to GitHub Pages

1. Build:
   ```bash
   flutter build web --release --base-href=/web-builder/
   ```

2. Create `gh-pages` branch:
   ```bash
   git checkout -b gh-pages
   ```

3. Copy build files:
   ```bash
   cp -r build/web/* .
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

4. Enable GitHub Pages in repository settings

## 🧪 Testing

### Run Tests

```bash
flutter test
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

## 🐛 Troubleshooting

### Issue: "Flutter not found"

**Solution:**
Add Flutter to your PATH:

```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

Add to your shell profile (`.bashrc`, `.zshrc`):

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### Issue: "Chrome not found"

**Solution:**
Specify Chrome path:

```bash
export CHROME_EXECUTABLE=/path/to/chrome
```

### Issue: Dependencies not resolving

**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Issue: Hot reload not working

**Solution:**
```bash
# Press R for hot restart instead of r
# Or restart the dev server:
flutter run -d chrome
```

### Issue: Build fails

**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build web
```

## 📊 Performance Optimization

### 1. Enable Tree Shaking

Tree shaking is automatically enabled in release builds.

### 2. Optimize Images

- Use WebP format
- Compress images
- Use appropriate sizes

### 3. Code Splitting

Use deferred loading:

```dart
import 'package:flutter/widgets.dart' deferred as widgets;

// Later, load it:
await widgets.loadLibrary();
```

### 4. Reduce Bundle Size

- Remove unused dependencies
- Use `--split-debug-info` flag
- Enable obfuscation: `--obfuscate`

### 5. Monitor Performance

```bash
flutter run --profile -d chrome
```

Then use Chrome DevTools for profiling.

## 🔒 Security Best Practices

1. **Never commit API keys**
   - Use environment variables
   - Keep `api_keys.dart` in `.gitignore`

2. **Use HTTPS in production**
   - Configure SSL certificates
   - Force HTTPS redirects

3. **Implement Content Security Policy**
   - Add CSP headers
   - Restrict resource loading

4. **Sanitize user input**
   - Validate all inputs
   - Prevent XSS attacks

## 📚 Additional Resources

- [Flutter Web Documentation](https://flutter.dev/web)
- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Deployment Guide](https://flutter.dev/docs/deployment/web)
- [WebAssembly Support](https://flutter.dev/wasm)

## 🆘 Getting Help

- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/flutter/flutter/issues)

---

**Happy Building! 🎉**
