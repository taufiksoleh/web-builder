import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ComponentModel {
  final String id;
  final String type;
  final String label;
  final Map<String, dynamic> properties;
  final List<ComponentModel> children;
  Offset position;
  Size size;

  ComponentModel({
    String? id,
    required this.type,
    required this.label,
    Map<String, dynamic>? properties,
    List<ComponentModel>? children,
    Offset? position,
    Size? size,
  })  : id = id ?? const Uuid().v4(),
        properties = properties ?? {},
        children = children ?? [],
        position = position ?? Offset.zero,
        size = size ?? const Size(200, 100);

  // Copy with method for immutability
  ComponentModel copyWith({
    String? id,
    String? type,
    String? label,
    Map<String, dynamic>? properties,
    List<ComponentModel>? children,
    Offset? position,
    Size? size,
  }) {
    return ComponentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      properties: properties ?? Map.from(this.properties),
      children: children ?? List.from(this.children),
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'properties': properties,
      'children': children.map((c) => c.toJson()).toList(),
      'position': {'dx': position.dx, 'dy': position.dy},
      'size': {'width': size.width, 'height': size.height},
    };
  }

  // Create from JSON
  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'],
      type: json['type'],
      label: json['label'],
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      children: (json['children'] as List?)
              ?.map((c) => ComponentModel.fromJson(c))
              .toList() ??
          [],
      position: json['position'] != null
          ? Offset(
              (json['position']['dx'] as num).toDouble(),
              (json['position']['dy'] as num).toDouble(),
            )
          : Offset.zero,
      size: json['size'] != null
          ? Size(
              (json['size']['width'] as num).toDouble(),
              (json['size']['height'] as num).toDouble(),
            )
          : const Size(200, 100),
    );
  }

  @override
  String toString() {
    return 'ComponentModel(id: $id, type: $type, label: $label)';
  }
}

// Predefined component templates
class ComponentTemplates {
  static ComponentModel container() {
    return ComponentModel(
      type: 'container',
      label: 'Container',
      properties: {
        'width': 200.0,
        'height': 100.0,
        'color': Colors.blue.shade100.value,
        'padding': 16.0,
        'borderRadius': 8.0,
      },
    );
  }

  static ComponentModel text() {
    return ComponentModel(
      type: 'text',
      label: 'Text',
      properties: {
        'content': 'Hello World',
        'fontSize': 16.0,
        'fontWeight': 'normal',
        'color': Colors.black87.value,
        'textAlign': 'left',
      },
    );
  }

  static ComponentModel button() {
    return ComponentModel(
      type: 'button',
      label: 'Button',
      properties: {
        'text': 'Click Me',
        'backgroundColor': Colors.blue.value,
        'textColor': Colors.white.value,
        'fontSize': 14.0,
        'padding': 16.0,
        'borderRadius': 8.0,
      },
    );
  }

  static ComponentModel image() {
    return ComponentModel(
      type: 'image',
      label: 'Image',
      properties: {
        'url': 'https://via.placeholder.com/300x200',
        'width': 300.0,
        'height': 200.0,
        'fit': 'cover',
        'borderRadius': 0.0,
      },
    );
  }

  static ComponentModel row() {
    return ComponentModel(
      type: 'row',
      label: 'Row',
      properties: {
        'mainAxisAlignment': 'start',
        'crossAxisAlignment': 'center',
        'spacing': 8.0,
      },
      children: [],
    );
  }

  static ComponentModel column() {
    return ComponentModel(
      type: 'column',
      label: 'Column',
      properties: {
        'mainAxisAlignment': 'start',
        'crossAxisAlignment': 'center',
        'spacing': 8.0,
      },
      children: [],
    );
  }

  static ComponentModel card() {
    return ComponentModel(
      type: 'card',
      label: 'Card',
      properties: {
        'width': 300.0,
        'height': 200.0,
        'elevation': 2.0,
        'borderRadius': 12.0,
        'padding': 16.0,
      },
      children: [],
    );
  }

  static ComponentModel textField() {
    return ComponentModel(
      type: 'textfield',
      label: 'Text Field',
      properties: {
        'placeholder': 'Enter text...',
        'width': 300.0,
        'fontSize': 14.0,
        'borderRadius': 8.0,
      },
    );
  }
}
