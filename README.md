# Svelte Web Builder

A modern, feature-rich drag-and-drop web page builder built with Svelte 5 and SvelteKit. Create beautiful, responsive web pages visually without writing code.

![Svelte 5](https://img.shields.io/badge/Svelte-5-FF3E00?style=flat&logo=svelte)
![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?style=flat&logo=typescript)
![Tailwind CSS](https://img.shields.io/badge/Tailwind-3-38B2AC?style=flat&logo=tailwind-css)

## ✨ Features

### Core Features
- 🎨 **Drag-and-Drop Interface** - Intuitive visual page builder
- 📱 **Responsive Design** - Preview in desktop, tablet, and mobile views
- 🔄 **Undo/Redo** - Full history management with keyboard shortcuts (Ctrl+Z/Ctrl+Y)
- 💾 **Auto-Save** - Automatic project saving every 30 seconds
- 🎯 **Export** - Generate clean HTML/CSS code
- 👁️ **Live Preview** - See your page in a real browser environment
- ⌨️ **Keyboard Shortcuts** - Efficient workflow with keyboard support

### Rich Component Library
- **Layout**: Container, Row, Column
- **Content**: Text, Heading, Button, Image
- **Forms**: Input, Textarea
- **Sections**: Card, Navbar, Hero, Footer

### Advanced Capabilities
- 🎨 **Visual Property Editor** - Edit styles, content, and layout properties
- 📊 **Layer Management** - Organize components with tree view
- 🔒 **Lock/Hide Components** - Control visibility and editing
- 🎯 **Component Selection** - Visual selection with keyboard support
- 💡 **Smart Defaults** - Pre-configured styles for all components
- 🔧 **Flexbox Support** - Full control over layout properties

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- npm or pnpm

### Installation

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Open browser
open http://localhost:5173
```

### Build for Production

```bash
# Build the app
npm run build

# Preview production build
npm run preview
```

## 🎯 Usage

### Creating a Page

1. **Add Components**: Drag components from the left palette onto the canvas, or click to add
2. **Edit Properties**: Select a component and use the properties panel on the right
3. **Organize Layers**: Use the layers panel to manage component hierarchy
4. **Preview**: Click the Preview button to see your page in action
5. **Export**: Click Export to download the HTML code

### Keyboard Shortcuts

- `Ctrl/Cmd + Z` - Undo
- `Ctrl/Cmd + Shift + Z` or `Ctrl/Cmd + Y` - Redo
- `Ctrl/Cmd + S` - Save project
- `Delete` or `Backspace` - Delete selected component

### Component Types

#### Layout Components
- **Container**: A flex container for organizing other components
- **Row**: Horizontal layout with flex-direction: row
- **Column**: Vertical layout with flex-direction: column

#### Content Components
- **Text**: Paragraph text with customizable styles
- **Heading**: Large heading text (H1)
- **Button**: Interactive button with link support
- **Image**: Responsive images with alt text

#### Form Components
- **Input**: Text input field with placeholder support
- **Textarea**: Multi-line text area

#### Section Components
- **Card**: Card-style container with shadow
- **Navbar**: Navigation bar layout
- **Hero**: Hero section for landing pages
- **Footer**: Page footer with copyright text

## 🏗️ Architecture

### Technology Stack
- **Svelte 5** - Latest version with runes for reactivity
- **SvelteKit** - Framework for building the application
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling
- **Lucide Svelte** - Beautiful icon library
- **nanoid** - Unique ID generation

### Project Structure

```
src/
├── lib/
│   ├── components/
│   │   ├── builder/          # Core builder components
│   │   │   ├── Canvas.svelte
│   │   │   ├── ComponentPalette.svelte
│   │   │   ├── ComponentRenderer.svelte
│   │   │   ├── PropertiesPanel.svelte
│   │   │   ├── LayersPanel.svelte
│   │   │   ├── Toolbar.svelte
│   │   │   ├── ExportModal.svelte
│   │   │   └── PreviewModal.svelte
│   │   └── ui/               # Reusable UI components
│   │       └── Modal.svelte
│   ├── stores/               # Svelte 5 runes stores
│   │   ├── canvas.svelte.ts  # Canvas state management
│   │   └── history.svelte.ts # Undo/redo history
│   ├── types/                # TypeScript definitions
│   │   └── index.ts
│   └── utils/                # Utility functions
│       ├── export.ts         # HTML export logic
│       └── storage.ts        # LocalStorage persistence
├── routes/
│   ├── +layout.svelte
│   └── +page.svelte          # Main builder page
└── app.css                   # Global styles
```

### State Management

The application uses **Svelte 5 runes** for reactive state management:

- **`canvasStore`**: Manages components, selection, and canvas state
- **`historyStore`**: Handles undo/redo functionality

State is stored in `.svelte.ts` files for universal reactivity.

## 🎨 Customization

### Adding New Components

1. Add the component type to `src/lib/types/index.ts`
2. Define default styles and props in `src/lib/stores/canvas.svelte.ts`
3. Add rendering logic in `src/lib/components/builder/ComponentRenderer.svelte`
4. Add to the palette in `src/lib/components/builder/ComponentPalette.svelte`

### Styling

Customize the theme in `tailwind.config.js`:

```js
theme: {
  extend: {
    colors: {
      primary: {
        // Your custom colors
      },
    },
  },
}
```

## 📦 Export Formats

Currently supports:
- **HTML** - Complete HTML file with inline styles

### Future Export Options (Planned)
- CSS file extraction
- React components
- Vue components
- Svelte components

## 🔧 Browser Support

- Chrome/Edge (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - feel free to use this for your own projects!

## 🙏 Acknowledgments

Built with modern web technologies and inspired by:
- [Builder.io](https://www.builder.io)
- [GrapesJS](https://grapesjs.com)
- [Webflow](https://webflow.com)

### Research Sources

This project was built using best practices from:
- [Svelte 5 Runes Documentation](https://svelte.dev/docs/svelte/$state)
- [svelte-dnd-action](https://github.com/isaacHagoel/svelte-dnd-action)
- [Patterns.dev](https://www.patterns.dev/)
- [Modern Web Design Patterns](https://web.dev/patterns)

---

**Built with ❤️ using Svelte 5**
