# Web Builder - Flutter Web Application

A modern, high-performance drag-and-drop web builder with AI assistance, built with Flutter Web.

## 🚀 Features

- ✨ **Drag-and-Drop Interface** - Intuitive visual builder
- 🤖 **AI Chat Assistant** - Claude API integration for natural language commands
- 🎨 **Material Design 3** - Beautiful, modern UI
- 📱 **Responsive Design** - Works on all screen sizes
- ⚡ **WebAssembly Support** - Optimized performance
- 🔧 **Component Library** - Pre-built, customizable components
- 💾 **Auto-Save** - Never lose your work
- 🎯 **Export Options** - Flutter, HTML/CSS/JS, React

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x with Web support
- **Language**: Dart 3.x
- **State Management**: Provider
- **UI**: Material Design 3
- **AI**: Claude API (Anthropic)
- **Backend**: Supabase (planned)

## 📋 Prerequisites

- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher
- Chrome (for development)

## 🏃 Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Enable Web Support (if not already enabled)

```bash
flutter config --enable-web
```

### 3. Run Development Server

```bash
flutter run -d chrome
```

### 4. Build for Production

```bash
# Standard build
flutter build web

# With WebAssembly (better performance)
flutter build web --wasm

# With CanvasKit renderer (better graphics)
flutter build web --web-renderer canvaskit
```

## 📁 Project Structure

```
web_builder/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── component_model.dart
│   │   └── project_model.dart
│   ├── providers/                # State management
│   │   ├── builder_provider.dart
│   │   └── ai_chat_provider.dart
│   ├── screens/                  # Main screens
│   │   └── builder_screen.dart
│   ├── widgets/                  # Reusable widgets
│   │   ├── component_palette.dart
│   │   ├── canvas_area.dart
│   │   ├── ai_chat_panel.dart
│   │   ├── properties_panel.dart
│   │   └── draggable_component.dart
│   ├── services/                 # Services (API, storage)
│   │   ├── ai_service.dart
│   │   └── storage_service.dart
│   ├── config/                   # Configuration
│   │   └── theme.dart
│   └── utils/                    # Utilities
│       └── constants.dart
├── web/                          # Web-specific files
├── test/                         # Tests
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## 🎨 Architecture

### Component-Based Design
- Every UI element is a reusable component
- Drag-and-drop using Flutter's built-in `Draggable` and `DragTarget`
- State management with Provider for reactive updates

### AI Integration
- Claude API for natural language processing
- Convert user prompts to Flutter widgets
- Smart component suggestions
- Code generation and optimization

## 🔧 Configuration

### AI Service Setup

1. Get your Claude API key from [Anthropic Console](https://console.anthropic.com/)
2. Create `lib/config/api_keys.dart`:

```dart
class ApiKeys {
  static const String claudeApiKey = 'YOUR_API_KEY_HERE';
}
```

3. Add to `.gitignore`:
```
lib/config/api_keys.dart
```

## 🌐 Web Deployment

### Deploy to Netlify

```bash
flutter build web
# Upload build/web folder to Netlify
```

### Deploy to Vercel

```bash
flutter build web
# Upload build/web folder to Vercel
```

### Deploy to Firebase Hosting

```bash
flutter build web
firebase deploy --only hosting
```

## 📝 Usage

### Creating a New Project

1. Click "New Project" in the header
2. Choose a template or start blank
3. Drag components from the palette to the canvas
4. Customize properties in the right panel
5. Use AI chat to make changes via natural language

### Using AI Assistant

```
Examples:
- "Add a button that says 'Get Started'"
- "Create a hero section with a gradient background"
- "Make this text larger and blue"
- "Add a three-column layout"
```

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📄 License

MIT License - feel free to use this for your own projects!

## 🙏 Acknowledgments

- Inspired by Lovable.dev and FlutterFlow
- Built with Flutter and Material Design 3
- AI powered by Anthropic Claude

## 📧 Support

For questions or support, please open an issue on GitHub.

---

Built with ❤️ using Flutter Web
