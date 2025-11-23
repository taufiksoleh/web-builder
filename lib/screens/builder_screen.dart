import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/builder_provider.dart';
import '../providers/ai_chat_provider.dart';
import '../widgets/component_palette.dart';
import '../widgets/canvas_area.dart';
import '../widgets/properties_panel.dart';
import '../widgets/ai_chat_panel.dart';

class BuilderScreen extends StatefulWidget {
  const BuilderScreen({super.key});

  @override
  State<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen> {
  bool _showAIChat = true;
  bool _showProperties = true;

  @override
  void initState() {
    super.initState();
    // Create initial project
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuilderProvider>().createNewProject('Untitled Project');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Row(
              children: [
                // Component Palette (Left)
                const ComponentPalette(),

                // Canvas Area (Center)
                const Expanded(
                  child: CanvasArea(),
                ),

                // Properties Panel (Right)
                if (_showProperties) const PropertiesPanel(),

                // AI Chat Panel (Far Right)
                if (_showAIChat) const AIChatPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final builderProvider = context.watch<BuilderProvider>();

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Logo
          Icon(
            Icons.web,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 8),
          Text(
            'Web Builder',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 24),

          // Project Name
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                initialValue: builderProvider.currentProject?.name ?? '',
                decoration: InputDecoration(
                  hintText: 'Project Name',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onChanged: (value) {
                  builderProvider.updateProjectName(value);
                },
              ),
            ),
          ),

          const Spacer(),

          // Undo/Redo
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: builderProvider.canUndo
                ? () => builderProvider.undo()
                : null,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: builderProvider.canRedo
                ? () => builderProvider.redo()
                : null,
            tooltip: 'Redo',
          ),

          const SizedBox(width: 8),
          const VerticalDivider(),
          const SizedBox(width: 8),

          // View toggles
          IconButton(
            icon: Icon(_showProperties ? Icons.space_dashboard : Icons.space_dashboard_outlined),
            onPressed: () {
              setState(() {
                _showProperties = !_showProperties;
              });
            },
            tooltip: 'Toggle Properties Panel',
          ),
          IconButton(
            icon: Icon(_showAIChat ? Icons.chat : Icons.chat_outlined),
            onPressed: () {
              setState(() {
                _showAIChat = !_showAIChat;
              });
            },
            tooltip: 'Toggle AI Chat',
          ),

          const SizedBox(width: 8),
          const VerticalDivider(),
          const SizedBox(width: 8),

          // Preview & Export
          OutlinedButton.icon(
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text('Preview'),
            onPressed: () {
              // TODO: Implement preview
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preview coming soon!')),
              );
            },
          ),

          const SizedBox(width: 8),

          ElevatedButton.icon(
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export'),
            onPressed: () {
              // TODO: Implement export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
