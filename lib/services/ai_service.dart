import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/ai_chat_provider.dart';
import '../utils/constants.dart';

class AIService {
  // NOTE: In production, move API key to environment variables
  // For now, this is a placeholder - user should add their own key
  static const String _apiKey = 'YOUR_CLAUDE_API_KEY_HERE';

  Future<String> sendMessage(
      String userMessage, List<ChatMessage> history) async {
    // If API key is not set, return helpful message
    if (_apiKey == 'YOUR_CLAUDE_API_KEY_HERE') {
      return _getMockResponse(userMessage);
    }

    try {
      // Build conversation history
      final messages = _buildMessages(userMessage, history);

      // Make API request to Claude
      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}${AppConstants.apiMessagesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': AppConstants.aiModel,
          'max_tokens': AppConstants.aiMaxTokens,
          'messages': messages,
          'system':
              'You are an AI assistant helping users build web applications with a drag-and-drop builder. '
              'Provide clear, concise instructions and suggestions for creating UI components. '
              'When users ask to add components, describe what should be added and how.',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] as String;
      } else {
        throw Exception(
            'AI API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  List<Map<String, dynamic>> _buildMessages(
      String userMessage, List<ChatMessage> history) {
    final messages = <Map<String, dynamic>>[];

    // Add recent history (last 10 messages for context)
    final recentHistory =
        history.length > 10 ? history.sublist(history.length - 10) : history;

    for (final msg in recentHistory) {
      messages.add({
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    // Add current message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });

    return messages;
  }

  // Mock response for when API key is not configured
  String _getMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('button')) {
      return 'I can help you add a button! Drag the "Button" component from the component palette on the left to your canvas. '
          'You can then customize it in the properties panel on the right - change the text, colors, size, and more.';
    } else if (lowerMessage.contains('text') || lowerMessage.contains('heading')) {
      return 'To add text to your page, drag the "Text" component from the palette to the canvas. '
          'You can edit the content and style it with different fonts, sizes, and colors in the properties panel.';
    } else if (lowerMessage.contains('container') || lowerMessage.contains('box')) {
      return 'Containers are great for organizing your layout! Drag a "Container" component to the canvas. '
          'You can set its size, background color, padding, and border radius in the properties panel.';
    } else if (lowerMessage.contains('image') || lowerMessage.contains('picture')) {
      return 'To add an image, drag the "Image" component to your canvas. '
          'In the properties panel, you can specify the image URL, adjust its size, and set how it fits within its bounds.';
    } else if (lowerMessage.contains('row') || lowerMessage.contains('horizontal')) {
      return 'A Row component lets you arrange items horizontally! Drag it to the canvas, '
          'then you can drag other components inside it. Adjust spacing and alignment in the properties panel.';
    } else if (lowerMessage.contains('column') || lowerMessage.contains('vertical')) {
      return 'A Column component arranges items vertically! Drag it to the canvas, '
          'then add components inside it. You can control spacing and alignment through the properties panel.';
    } else if (lowerMessage.contains('help') ||
        lowerMessage.contains('how') ||
        lowerMessage.contains('?')) {
      return 'I\'m here to help you build your web application! You can:\n\n'
          '• Ask me to explain components\n'
          '• Get suggestions for layouts\n'
          '• Learn about best practices\n'
          '• Ask for help with specific features\n\n'
          'Try asking: "How do I add a button?" or "Create a hero section"';
    } else {
      return 'I understand you want to work on: "$userMessage"\n\n'
          'Here\'s what I suggest:\n'
          '1. Browse the component palette on the left\n'
          '2. Drag components to the canvas in the center\n'
          '3. Click on components to select and edit them\n'
          '4. Customize properties in the panel on the right\n\n'
          'Feel free to ask me specific questions about components or layouts!';
    }
  }
}
