import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save project
  Future<bool> saveProject(ProjectModel project) async {
    try {
      if (_prefs == null) await init();

      final projectJson = jsonEncode(project.toJson());
      await _prefs!.setString('project_${project.id}', projectJson);

      // Update project list
      await _addToProjectList(project.id);

      // Set as current project
      await _prefs!.setString(AppConstants.storageKeyCurrentProject, project.id);

      return true;
    } catch (e) {
      print('Error saving project: $e');
      return false;
    }
  }

  // Load project
  Future<ProjectModel?> loadProject(String projectId) async {
    try {
      if (_prefs == null) await init();

      final projectJson = _prefs!.getString('project_$projectId');
      if (projectJson == null) return null;

      final projectData = jsonDecode(projectJson);
      return ProjectModel.fromJson(projectData);
    } catch (e) {
      print('Error loading project: $e');
      return null;
    }
  }

  // Load current project
  Future<ProjectModel?> loadCurrentProject() async {
    try {
      if (_prefs == null) await init();

      final currentProjectId =
          _prefs!.getString(AppConstants.storageKeyCurrentProject);
      if (currentProjectId == null) return null;

      return await loadProject(currentProjectId);
    } catch (e) {
      print('Error loading current project: $e');
      return null;
    }
  }

  // Get all projects
  Future<List<ProjectModel>> getAllProjects() async {
    try {
      if (_prefs == null) await init();

      final projectIds = _prefs!.getStringList(AppConstants.storageKeyProjects) ?? [];
      final projects = <ProjectModel>[];

      for (final id in projectIds) {
        final project = await loadProject(id);
        if (project != null) {
          projects.add(project);
        }
      }

      return projects;
    } catch (e) {
      print('Error getting all projects: $e');
      return [];
    }
  }

  // Delete project
  Future<bool> deleteProject(String projectId) async {
    try {
      if (_prefs == null) await init();

      await _prefs!.remove('project_$projectId');
      await _removeFromProjectList(projectId);

      // If this was the current project, clear it
      final currentProjectId =
          _prefs!.getString(AppConstants.storageKeyCurrentProject);
      if (currentProjectId == projectId) {
        await _prefs!.remove(AppConstants.storageKeyCurrentProject);
      }

      return true;
    } catch (e) {
      print('Error deleting project: $e');
      return false;
    }
  }

  // Add project to list
  Future<void> _addToProjectList(String projectId) async {
    final projectIds =
        _prefs!.getStringList(AppConstants.storageKeyProjects) ?? [];
    if (!projectIds.contains(projectId)) {
      projectIds.add(projectId);
      await _prefs!.setStringList(AppConstants.storageKeyProjects, projectIds);
    }
  }

  // Remove project from list
  Future<void> _removeFromProjectList(String projectId) async {
    final projectIds =
        _prefs!.getStringList(AppConstants.storageKeyProjects) ?? [];
    projectIds.remove(projectId);
    await _prefs!.setStringList(AppConstants.storageKeyProjects, projectIds);
  }

  // Clear all data
  Future<bool> clearAll() async {
    try {
      if (_prefs == null) await init();
      await _prefs!.clear();
      return true;
    } catch (e) {
      print('Error clearing storage: $e');
      return false;
    }
  }
}
