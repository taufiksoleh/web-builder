import 'package:flutter/material.dart';
import '../models/component_model.dart';
import '../utils/constants.dart';

class ComponentPalette extends StatefulWidget {
  const ComponentPalette({super.key});

  @override
  State<ComponentPalette> createState() => _ComponentPaletteState();
}

class _ComponentPaletteState extends State<ComponentPalette> {
  String _selectedCategory = ComponentCategories.layout;

  final Map<String, List<PaletteItem>> _componentsByCategory = {
    ComponentCategories.layout: [
      PaletteItem(
        icon: Icons.crop_square,
        label: 'Container',
        color: Colors.blue,
        createComponent: ComponentTemplates.container,
      ),
      PaletteItem(
        icon: Icons.view_column,
        label: 'Row',
        color: Colors.purple,
        createComponent: ComponentTemplates.row,
      ),
      PaletteItem(
        icon: Icons.view_agenda,
        label: 'Column',
        color: Colors.indigo,
        createComponent: ComponentTemplates.column,
      ),
      PaletteItem(
        icon: Icons.credit_card,
        label: 'Card',
        color: Colors.teal,
        createComponent: ComponentTemplates.card,
      ),
    ],
    ComponentCategories.text: [
      PaletteItem(
        icon: Icons.text_fields,
        label: 'Text',
        color: Colors.orange,
        createComponent: ComponentTemplates.text,
      ),
    ],
    ComponentCategories.buttons: [
      PaletteItem(
        icon: Icons.smart_button,
        label: 'Button',
        color: Colors.green,
        createComponent: ComponentTemplates.button,
      ),
    ],
    ComponentCategories.input: [
      PaletteItem(
        icon: Icons.input,
        label: 'Text Field',
        color: Colors.cyan,
        createComponent: ComponentTemplates.textField,
      ),
    ],
    ComponentCategories.media: [
      PaletteItem(
        icon: Icons.image,
        label: 'Image',
        color: Colors.pink,
        createComponent: ComponentTemplates.image,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Components',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search components...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Category Tabs
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _componentsByCategory.keys.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(),

          // Components List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _componentsByCategory[_selectedCategory]!
                  .map((item) => _buildComponentItem(item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentItem(PaletteItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Draggable<ComponentModel>(
        data: item.createComponent(),
        feedback: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              border: Border.all(color: item.color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, color: item.color, size: 24),
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _buildItemCard(item),
        ),
        child: _buildItemCard(item),
      ),
    );
  }

  Widget _buildItemCard(PaletteItem item) {
    return Card(
      child: InkWell(
        onTap: () {
          // Optional: Add component on tap instead of drag
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Drag to canvas',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.drag_indicator,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaletteItem {
  final IconData icon;
  final String label;
  final Color color;
  final ComponentModel Function() createComponent;

  PaletteItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.createComponent,
  });
}
