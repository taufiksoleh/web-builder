import 'package:flutter/material.dart';
import '../models/component_model.dart';
import '../models/project_model.dart';

class BuilderProvider extends ChangeNotifier {
  ProjectModel? _currentProject;
  ComponentModel? _selectedComponent;
  bool _isGridEnabled = true;
  double _canvasScale = 1.0;
  final List<ProjectModel> _projectHistory = [];
  int _historyIndex = -1;

  // Getters
  ProjectModel? get currentProject => _currentProject;
  ComponentModel? get selectedComponent => _selectedComponent;
  List<ComponentModel> get components => _currentProject?.components ?? [];
  bool get isGridEnabled => _isGridEnabled;
  double get canvasScale => _canvasScale;
  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _projectHistory.length - 1;

  // Initialize new project
  void createNewProject(String name) {
    _currentProject = ProjectModel(name: name);
    _selectedComponent = null;
    _addToHistory();
    notifyListeners();
  }

  // Load existing project
  void loadProject(ProjectModel project) {
    _currentProject = project;
    _selectedComponent = null;
    _projectHistory.clear();
    _historyIndex = -1;
    _addToHistory();
    notifyListeners();
  }

  // Add component to canvas
  void addComponent(ComponentModel component) {
    if (_currentProject == null) return;

    _currentProject!.components.add(component);
    _currentProject!.updatedAt = DateTime.now();
    _addToHistory();
    notifyListeners();
  }

  // Remove component
  void removeComponent(String componentId) {
    if (_currentProject == null) return;

    _currentProject!.components.removeWhere((c) => c.id == componentId);
    if (_selectedComponent?.id == componentId) {
      _selectedComponent = null;
    }
    _currentProject!.updatedAt = DateTime.now();
    _addToHistory();
    notifyListeners();
  }

  // Update component
  void updateComponent(String componentId, ComponentModel updatedComponent) {
    if (_currentProject == null) return;

    final index =
        _currentProject!.components.indexWhere((c) => c.id == componentId);
    if (index != -1) {
      _currentProject!.components[index] = updatedComponent;
      if (_selectedComponent?.id == componentId) {
        _selectedComponent = updatedComponent;
      }
      _currentProject!.updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  // Update component position
  void updateComponentPosition(String componentId, Offset position) {
    if (_currentProject == null) return;

    final component =
        _currentProject!.components.firstWhere((c) => c.id == componentId);
    component.position = position;
    _currentProject!.updatedAt = DateTime.now();
    notifyListeners();
  }

  // Update component property
  void updateComponentProperty(
      String componentId, String propertyName, dynamic value) {
    if (_currentProject == null) return;

    final component =
        _currentProject!.components.firstWhere((c) => c.id == componentId);
    component.properties[propertyName] = value;

    if (_selectedComponent?.id == componentId) {
      _selectedComponent = component;
    }

    _currentProject!.updatedAt = DateTime.now();
    notifyListeners();
  }

  // Select component
  void selectComponent(ComponentModel? component) {
    _selectedComponent = component;
    notifyListeners();
  }

  // Toggle grid
  void toggleGrid() {
    _isGridEnabled = !_isGridEnabled;
    notifyListeners();
  }

  // Update canvas scale (zoom)
  void updateCanvasScale(double scale) {
    _canvasScale = scale.clamp(0.25, 2.0);
    notifyListeners();
  }

  // Undo/Redo functionality
  void _addToHistory() {
    if (_currentProject == null) return;

    // Remove any redo history
    if (_historyIndex < _projectHistory.length - 1) {
      _projectHistory.removeRange(_historyIndex + 1, _projectHistory.length);
    }

    // Add current state
    _projectHistory.add(_deepCopyProject(_currentProject!));
    _historyIndex = _projectHistory.length - 1;

    // Limit history to 50 states
    if (_projectHistory.length > 50) {
      _projectHistory.removeAt(0);
      _historyIndex--;
    }
  }

  void undo() {
    if (!canUndo) return;

    _historyIndex--;
    _currentProject = _deepCopyProject(_projectHistory[_historyIndex]);
    _selectedComponent = null;
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;

    _historyIndex++;
    _currentProject = _deepCopyProject(_projectHistory[_historyIndex]);
    _selectedComponent = null;
    notifyListeners();
  }

  // Deep copy project for history
  ProjectModel _deepCopyProject(ProjectModel project) {
    return ProjectModel.fromJson(project.toJson());
  }

  // Clear all
  void clear() {
    _currentProject?.components.clear();
    _selectedComponent = null;
    _addToHistory();
    notifyListeners();
  }

  // Duplicate component
  void duplicateComponent(String componentId) {
    if (_currentProject == null) return;

    final original =
        _currentProject!.components.firstWhere((c) => c.id == componentId);
    final duplicate = ComponentModel.fromJson(original.toJson());

    // Offset the position slightly
    duplicate.position = Offset(
      original.position.dx + 20,
      original.position.dy + 20,
    );

    addComponent(duplicate);
  }

  // Export project
  Map<String, dynamic> exportProject() {
    if (_currentProject == null) return {};
    return _currentProject!.toJson();
  }

  // Update project name
  void updateProjectName(String name) {
    if (_currentProject == null) return;
    _currentProject!.name = name;
    _currentProject!.updatedAt = DateTime.now();
    notifyListeners();
  }
}
