import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/builder_provider.dart';
import '../models/component_model.dart';
import 'draggable_component.dart';

class CanvasArea extends StatefulWidget {
  const CanvasArea({super.key});

  @override
  State<CanvasArea> createState() => _CanvasAreaState();
}

class _CanvasAreaState extends State<CanvasArea> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final builderProvider = context.watch<BuilderProvider>();

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // Canvas Toolbar
          _buildToolbar(context, builderProvider),

          // Canvas
          Expanded(
            child: DragTarget<ComponentModel>(
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (details) {
                // Get the drop position relative to the canvas
                final renderBox = context.findRenderObject() as RenderBox;
                final localPosition = renderBox.globalToLocal(details.offset);

                // Create component at drop position
                final component = details.data;
                component.position = Offset(
                  localPosition.dx - 100, // Offset for component center
                  localPosition.dy - 150, // Accounting for toolbar
                );

                builderProvider.addComponent(component);
              },
              builder: (context, candidateData, rejectedData) {
                return Stack(
                  children: [
                    // Grid Background
                    if (builderProvider.isGridEnabled)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: GridPainter(
                            color: theme.dividerColor.withOpacity(0.3),
                          ),
                        ),
                      ),

                    // Canvas Content
                    InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: Container(
                        width: 2000,
                        height: 2000,
                        alignment: Alignment.topLeft,
                        child: Stack(
                          children: [
                            // Canvas Background
                            Positioned(
                              left: 100,
                              top: 100,
                              child: Container(
                                width: 1200,
                                height: 1600,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: theme.dividerColor,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Components
                            ...builderProvider.components.map((component) {
                              return DraggableComponent(
                                key: ValueKey(component.id),
                                component: component,
                                offset: Offset(
                                  component.position.dx + 100,
                                  component.position.dy + 100,
                                ),
                              );
                            }),

                            // Drop indicator
                            if (candidateData.isNotEmpty)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Drop zone hint
                    if (builderProvider.components.isEmpty)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_box_outlined,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Drag components here to get started',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'or ask the AI assistant for help',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, BuilderProvider provider) {
    final theme = Theme.of(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          // Zoom controls
          IconButton(
            icon: const Icon(Icons.zoom_out, size: 20),
            onPressed: () {
              final newScale = provider.canvasScale - 0.1;
              provider.updateCanvasScale(newScale);
              _transformationController.value = Matrix4.identity()
                ..scale(newScale);
            },
            tooltip: 'Zoom Out',
          ),
          Text(
            '${(provider.canvasScale * 100).toInt()}%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, size: 20),
            onPressed: () {
              final newScale = provider.canvasScale + 0.1;
              provider.updateCanvasScale(newScale);
              _transformationController.value = Matrix4.identity()
                ..scale(newScale);
            },
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.fit_screen, size: 20),
            onPressed: () {
              provider.updateCanvasScale(1.0);
              _transformationController.value = Matrix4.identity();
            },
            tooltip: 'Reset Zoom',
          ),

          const VerticalDivider(),

          // Grid toggle
          IconButton(
            icon: Icon(
              provider.isGridEnabled ? Icons.grid_on : Icons.grid_off,
              size: 20,
            ),
            onPressed: provider.toggleGrid,
            tooltip: 'Toggle Grid',
          ),

          const Spacer(),

          // Component count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${provider.components.length} components',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Clear all
          if (provider.components.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('Clear All'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Canvas'),
                    content: const Text(
                      'Are you sure you want to remove all components?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  final double gridSize;

  GridPainter({
    required this.color,
    this.gridSize = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.gridSize != gridSize;
  }
}
