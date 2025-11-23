import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/component_model.dart';
import '../providers/builder_provider.dart';

class DraggableComponent extends StatefulWidget {
  final ComponentModel component;
  final Offset offset;

  const DraggableComponent({
    super.key,
    required this.component,
    required this.offset,
  });

  @override
  State<DraggableComponent> createState() => _DraggableComponentState();
}

class _DraggableComponentState extends State<DraggableComponent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final builderProvider = context.watch<BuilderProvider>();
    final isSelected = builderProvider.selectedComponent?.id == widget.component.id;

    return Positioned(
      left: widget.offset.dx,
      top: widget.offset.dy,
      child: Draggable(
        feedback: Opacity(
          opacity: 0.7,
          child: _buildComponent(isDragging: true),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildComponent(),
        ),
        onDragEnd: (details) {
          // Update component position
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            builderProvider.updateComponentPosition(
              widget.component.id,
              Offset(
                details.offset.dx - 100,
                details.offset.dy - 150,
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            builderProvider.selectComponent(widget.component);
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Stack(
              children: [
                _buildComponent(),

                // Selection indicator
                if (isSelected || _isHovered)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Colors.blue
                              : Colors.blue.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          widget.component.properties['borderRadius'] ?? 0.0,
                        ),
                      ),
                    ),
                  ),

                // Actions toolbar
                if (isSelected)
                  Positioned(
                    top: -32,
                    right: 0,
                    child: _buildActionsToolbar(builderProvider),
                  ),

                // Resize handles (if selected)
                if (isSelected) ..._buildResizeHandles(builderProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComponent({bool isDragging = false}) {
    switch (widget.component.type) {
      case 'container':
        return _buildContainer();
      case 'text':
        return _buildText();
      case 'button':
        return _buildButton();
      case 'image':
        return _buildImage();
      case 'row':
        return _buildRow();
      case 'column':
        return _buildColumn();
      case 'card':
        return _buildCard();
      case 'textfield':
        return _buildTextField();
      default:
        return _buildPlaceholder();
    }
  }

  Widget _buildContainer() {
    final props = widget.component.properties;
    return Container(
      width: (props['width'] as num?)?.toDouble() ?? 200,
      height: (props['height'] as num?)?.toDouble() ?? 100,
      padding: EdgeInsets.all((props['padding'] as num?)?.toDouble() ?? 16),
      decoration: BoxDecoration(
        color: Color(props['color'] as int? ?? Colors.blue.shade100.value),
        borderRadius: BorderRadius.circular(
          (props['borderRadius'] as num?)?.toDouble() ?? 8,
        ),
      ),
      child: props['children'] != null
          ? Column(
              children: (props['children'] as List)
                  .map((c) => Text(c.toString()))
                  .toList(),
            )
          : null,
    );
  }

  Widget _buildText() {
    final props = widget.component.properties;
    return Container(
      constraints: const BoxConstraints(minWidth: 50, minHeight: 30),
      child: Text(
        props['content'] as String? ?? 'Text',
        style: TextStyle(
          fontSize: (props['fontSize'] as num?)?.toDouble() ?? 16,
          fontWeight: props['fontWeight'] == 'bold'
              ? FontWeight.bold
              : FontWeight.normal,
          color: Color(props['color'] as int? ?? Colors.black87.value),
        ),
        textAlign: _parseTextAlign(props['textAlign'] as String?),
      ),
    );
  }

  Widget _buildButton() {
    final props = widget.component.properties;
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Color(props['backgroundColor'] as int? ?? Colors.blue.value),
        foregroundColor:
            Color(props['textColor'] as int? ?? Colors.white.value),
        padding: EdgeInsets.all((props['padding'] as num?)?.toDouble() ?? 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            (props['borderRadius'] as num?)?.toDouble() ?? 8,
          ),
        ),
      ),
      child: Text(
        props['text'] as String? ?? 'Button',
        style: TextStyle(
          fontSize: (props['fontSize'] as num?)?.toDouble() ?? 14,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final props = widget.component.properties;
    return Container(
      width: (props['width'] as num?)?.toDouble() ?? 300,
      height: (props['height'] as num?)?.toDouble() ?? 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          (props['borderRadius'] as num?)?.toDouble() ?? 0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        props['url'] as String? ?? 'https://via.placeholder.com/300x200',
        fit: _parseBoxFit(props['fit'] as String?),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 48),
          );
        },
      ),
    );
  }

  Widget _buildRow() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Icon(Icons.view_column, color: Colors.purple),
          SizedBox(width: 8),
          Text('Row Container', style: TextStyle(color: Colors.purple)),
        ],
      ),
    );
  }

  Widget _buildColumn() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo.withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.view_agenda, color: Colors.indigo),
          SizedBox(height: 8),
          Text('Column Container', style: TextStyle(color: Colors.indigo)),
        ],
      ),
    );
  }

  Widget _buildCard() {
    final props = widget.component.properties;
    return Card(
      elevation: (props['elevation'] as num?)?.toDouble() ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          (props['borderRadius'] as num?)?.toDouble() ?? 12,
        ),
      ),
      child: Container(
        width: (props['width'] as num?)?.toDouble() ?? 300,
        height: (props['height'] as num?)?.toDouble() ?? 200,
        padding: EdgeInsets.all((props['padding'] as num?)?.toDouble() ?? 16),
        child: const Center(child: Text('Card Content')),
      ),
    );
  }

  Widget _buildTextField() {
    final props = widget.component.properties;
    return SizedBox(
      width: (props['width'] as num?)?.toDouble() ?? 300,
      child: TextField(
        decoration: InputDecoration(
          hintText: props['placeholder'] as String? ?? 'Enter text...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              (props['borderRadius'] as num?)?.toDouble() ?? 8,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: (props['fontSize'] as num?)?.toDouble() ?? 14,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 200,
      height: 100,
      color: Colors.grey[300],
      child: Center(
        child: Text('Unknown: ${widget.component.type}'),
      ),
    );
  }

  Widget _buildActionsToolbar(BuilderProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.content_copy,
            onPressed: () => provider.duplicateComponent(widget.component.id),
            tooltip: 'Duplicate',
          ),
          _buildActionButton(
            icon: Icons.delete,
            onPressed: () => provider.removeComponent(widget.component.id),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 16, color: Colors.white),
        onPressed: onPressed,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(),
      ),
    );
  }

  List<Widget> _buildResizeHandles(BuilderProvider provider) {
    const handleSize = 8.0;
    final props = widget.component.properties;
    final width = (props['width'] as num?)?.toDouble() ?? 200;
    final height = (props['height'] as num?)?.toDouble() ?? 100;

    return [
      // Bottom-right resize handle
      Positioned(
        right: -handleSize / 2,
        bottom: -handleSize / 2,
        child: GestureDetector(
          onPanUpdate: (details) {
            provider.updateComponentProperty(
              widget.component.id,
              'width',
              (width + details.delta.dx).clamp(50.0, 2000.0),
            );
            provider.updateComponentProperty(
              widget.component.id,
              'height',
              (height + details.delta.dy).clamp(30.0, 2000.0),
            );
          },
          child: Container(
            width: handleSize,
            height: handleSize,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ];
  }

  TextAlign _parseTextAlign(String? align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  BoxFit _parseBoxFit(String? fit) {
    switch (fit) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      default:
        return BoxFit.cover;
    }
  }
}
