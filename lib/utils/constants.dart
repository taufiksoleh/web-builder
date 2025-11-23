class AppConstants {
  // App Info
  static const String appName = 'Web Builder';
  static const String appVersion = '1.0.0';

  // Canvas Settings
  static const double canvasMinWidth = 320.0;
  static const double canvasMaxWidth = 1920.0;
  static const double canvasDefaultWidth = 1200.0;
  static const double canvasGridSize = 8.0;

  // Auto-save Settings
  static const Duration autoSaveInterval = Duration(seconds: 3);

  // Component Types
  static const String componentTypeContainer = 'container';
  static const String componentTypeText = 'text';
  static const String componentTypeButton = 'button';
  static const String componentTypeImage = 'image';
  static const String componentTypeRow = 'row';
  static const String componentTypeColumn = 'column';
  static const String componentTypeCard = 'card';
  static const String componentTypeTextField = 'textfield';

  // AI Settings
  static const String aiModel = 'claude-sonnet-4.5';
  static const int aiMaxTokens = 4096;

  // Storage Keys
  static const String storageKeyProjects = 'projects';
  static const String storageKeyCurrentProject = 'current_project';
  static const String storageKeySettings = 'settings';

  // API Endpoints (to be configured)
  static const String apiBaseUrl = 'https://api.anthropic.com/v1';
  static const String apiMessagesEndpoint = '/messages';
}

class ComponentCategories {
  static const String layout = 'Layout';
  static const String text = 'Text';
  static const String buttons = 'Buttons';
  static const String input = 'Input';
  static const String media = 'Media';
  static const String navigation = 'Navigation';
}
