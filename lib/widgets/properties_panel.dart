import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/builder_provider.dart';

class PropertiesPanel extends StatelessWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final builderProvider = context.watch<BuilderProvider>();
    final selectedComponent = builderProvider.selectedComponent;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: selectedComponent == null
          ? _buildEmptyState()
          : _buildPropertiesForm(context, selectedComponent, builderProvider),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.settings,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No component selected',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Click on a component to edit',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesForm(
    BuildContext context,
    component,
    BuilderProvider provider,
  ) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Row(
          children: [
            Icon(
              _getIconForType(component.type),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              component.label,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          'ID: ${component.id.substring(0, 8)}...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),

        const Divider(height: 32),

        // Properties based on component type
        ..._buildPropertiesForType(context, component, provider),
      ],
    );
  }

  List<Widget> _buildPropertiesForType(
    BuildContext context,
    component,
    BuilderProvider provider,
  ) {
    final widgets = <Widget>[];

    // Common properties
    widgets.addAll([
      _buildSectionHeader('Position & Size'),
      if (component.properties.containsKey('width'))
        _buildNumberField(
          label: 'Width',
          value: component.properties['width'],
          onChanged: (value) => provider.updateComponentProperty(
            component.id,
            'width',
            value,
          ),
        ),
      if (component.properties.containsKey('height'))
        _buildNumberField(
          label: 'Height',
          value: component.properties['height'],
          onChanged: (value) => provider.updateComponentProperty(
            component.id,
            'height',
            value,
          ),
        ),
    ]);

    // Type-specific properties
    switch (component.type) {
      case 'container':
        widgets.addAll([
          const SizedBox(height: 16),
          _buildSectionHeader('Style'),
          _buildColorField(
            label: 'Background Color',
            value: component.properties['color'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'color',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Padding',
            value: component.properties['padding'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'padding',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Border Radius',
            value: component.properties['borderRadius'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'borderRadius',
              value,
            ),
          ),
        ]);
        break;

      case 'text':
        widgets.addAll([
          const SizedBox(height: 16),
          _buildSectionHeader('Content'),
          _buildTextField(
            label: 'Text',
            value: component.properties['content'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'content',
              value,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Style'),
          _buildNumberField(
            label: 'Font Size',
            value: component.properties['fontSize'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'fontSize',
              value,
            ),
          ),
          _buildDropdown(
            label: 'Font Weight',
            value: component.properties['fontWeight'],
            items: const ['normal', 'bold'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'fontWeight',
              value,
            ),
          ),
          _buildColorField(
            label: 'Text Color',
            value: component.properties['color'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'color',
              value,
            ),
          ),
          _buildDropdown(
            label: 'Text Align',
            value: component.properties['textAlign'],
            items: const ['left', 'center', 'right', 'justify'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'textAlign',
              value,
            ),
          ),
        ]);
        break;

      case 'button':
        widgets.addAll([
          const SizedBox(height: 16),
          _buildSectionHeader('Content'),
          _buildTextField(
            label: 'Button Text',
            value: component.properties['text'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'text',
              value,
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Style'),
          _buildColorField(
            label: 'Background Color',
            value: component.properties['backgroundColor'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'backgroundColor',
              value,
            ),
          ),
          _buildColorField(
            label: 'Text Color',
            value: component.properties['textColor'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'textColor',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Font Size',
            value: component.properties['fontSize'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'fontSize',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Padding',
            value: component.properties['padding'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'padding',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Border Radius',
            value: component.properties['borderRadius'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'borderRadius',
              value,
            ),
          ),
        ]);
        break;

      case 'image':
        widgets.addAll([
          const SizedBox(height: 16),
          _buildSectionHeader('Image'),
          _buildTextField(
            label: 'Image URL',
            value: component.properties['url'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'url',
              value,
            ),
          ),
          _buildDropdown(
            label: 'Fit',
            value: component.properties['fit'],
            items: const ['cover', 'contain', 'fill', 'fitWidth', 'fitHeight'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'fit',
              value,
            ),
          ),
          _buildNumberField(
            label: 'Border Radius',
            value: component.properties['borderRadius'],
            onChanged: (value) => provider.updateComponentProperty(
              component.id,
              'borderRadius',
              value,
            ),
          ),
        ]);
        break;
    }

    return widgets;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required dynamic value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(text: value?.toString() ?? ''),
            onChanged: onChanged,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required dynamic value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: TextEditingController(
              text: (value as num?)?.toDouble().toString() ?? '0',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
            ],
            onChanged: (text) {
              final number = double.tryParse(text);
              if (number != null) {
                onChanged(number);
              }
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorField({
    required String label,
    required dynamic value,
    required ValueChanged<int> onChanged,
  }) {
    final color = Color(value as int? ?? Colors.blue.value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement color picker
                },
                child: const Text('Change'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required dynamic value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value?.toString() ?? items.first,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) onChanged(newValue);
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'container':
        return Icons.crop_square;
      case 'text':
        return Icons.text_fields;
      case 'button':
        return Icons.smart_button;
      case 'image':
        return Icons.image;
      case 'row':
        return Icons.view_column;
      case 'column':
        return Icons.view_agenda;
      case 'card':
        return Icons.credit_card;
      case 'textfield':
        return Icons.input;
      default:
        return Icons.widgets;
    }
  }
}
