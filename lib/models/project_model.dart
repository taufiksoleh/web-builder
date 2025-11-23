import 'package:uuid/uuid.dart';
import 'component_model.dart';

class ProjectModel {
  final String id;
  String name;
  String description;
  final DateTime createdAt;
  DateTime updatedAt;
  List<ComponentModel> components;
  Map<String, dynamic> settings;

  ProjectModel({
    String? id,
    required this.name,
    this.description = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ComponentModel>? components,
    Map<String, dynamic>? settings,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        components = components ?? [],
        settings = settings ?? _defaultSettings();

  static Map<String, dynamic> _defaultSettings() {
    return {
      'canvasWidth': 1200.0,
      'canvasHeight': 800.0,
      'backgroundColor': 0xFFFFFFFF,
      'gridEnabled': true,
      'gridSize': 8.0,
      'snapToGrid': true,
    };
  }

  // Copy with method
  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ComponentModel>? components,
    Map<String, dynamic>? settings,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      components: components ?? List.from(this.components),
      settings: settings ?? Map.from(this.settings),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'components': components.map((c) => c.toJson()).toList(),
      'settings': settings,
    };
  }

  // Create from JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      components: (json['components'] as List?)
              ?.map((c) => ComponentModel.fromJson(c))
              .toList() ??
          [],
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, components: ${components.length})';
  }
}
