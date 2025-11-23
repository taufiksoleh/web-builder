# ⚡ Quick Start Guide

Get up and running with Web Builder in 5 minutes!

## 🚀 Fast Setup

### 1. Prerequisites Check

```bash
# Check Flutter installation
flutter --version

# Should show: Flutter 3.2.0 or higher
```

Don't have Flutter? [Install it here](https://flutter.dev/docs/get-started/install)

### 2. Enable Web Support

```bash
flutter config --enable-web
```

### 3. Get Dependencies

```bash
cd web-builder
flutter pub get
```

### 4. Run the App

```bash
flutter run -d chrome
```

That's it! The app should open in Chrome automatically. 🎉

## 🎨 First Steps

### Add Your First Component

1. **Find the Component Palette** on the left sidebar
2. **Drag a component** (try "Container" or "Button")
3. **Drop it on the canvas** in the center
4. **Click the component** to select it
5. **Edit properties** in the right panel

### Try the AI Assistant

1. **Find the AI Chat Panel** on the far right
2. **Type a message** like "How do I add a button?"
3. **Get instant help** from the AI assistant

### Customize Components

1. **Select a component** on the canvas
2. **See the Properties Panel** on the right
3. **Change colors, sizes, text, etc.**
4. **Watch updates in real-time**

## 🎯 Common Tasks

### Save Your Work

Your work auto-saves every 3 seconds! But you can also manually export:

1. Click **"Export"** button in the header
2. Your project will be saved as JSON

### Undo/Redo

- **Undo:** Click the undo button or press `Ctrl+Z`
- **Redo:** Click the redo button or press `Ctrl+Y`

### Zoom In/Out

Use the zoom controls in the canvas toolbar:
- **Zoom In:** `+` button
- **Zoom Out:** `-` button
- **Reset:** Fit screen button

### Clear Canvas

1. Click **"Clear All"** in the canvas toolbar
2. Confirm to remove all components

## 🔑 Enable AI Features (Optional)

1. Get API key from [Anthropic Console](https://console.anthropic.com/)

2. Create file: `lib/config/api_keys.dart`

3. Add:
   ```dart
   class ApiKeys {
     static const String claudeApiKey = 'your-key-here';
   }
   ```

> Without an API key, the AI will use helpful mock responses for testing.

## 🏗️ Build for Production

### Standard Build

```bash
flutter build web
```

### With WebAssembly (Faster!)

```bash
flutter build web --wasm
```

Output will be in `build/web/` - ready to deploy!

## 📦 Quick Deploy

### Netlify (Easiest)

```bash
# Build
flutter build web --release --wasm

# Deploy
cd build/web
npx netlify-cli deploy --prod
```

### Vercel

```bash
# Build
flutter build web --release --wasm

# Deploy
npx vercel build/web
```

## 🐛 Troubleshooting

### App won't start?

```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Components not showing?

- Check browser console (F12)
- Refresh the page
- Try clearing browser cache

### Hot reload not working?

Press `R` (capital R) for hot restart instead of `r`

## 📚 Next Steps

- Read the full [README.md](README.md)
- Check out [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup
- See [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

## 🆘 Need Help?

- Check the AI Assistant in the app
- Open an issue on GitHub
- Read the documentation

## 🎉 You're Ready!

Start building amazing web applications with drag-and-drop and AI!

---

**Pro Tips:**
- Use the grid (toggle in canvas toolbar) for precise alignment
- Duplicate components by clicking the duplicate button when selected
- Ask the AI for layout suggestions
- Experiment with different component combinations
