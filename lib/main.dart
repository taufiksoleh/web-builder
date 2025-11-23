import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/builder_provider.dart';
import 'providers/ai_chat_provider.dart';
import 'screens/builder_screen.dart';
import 'config/theme.dart';

void main() {
  runApp(const WebBuilderApp());
}

class WebBuilderApp extends StatelessWidget {
  const WebBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuilderProvider()),
        ChangeNotifierProvider(create: (_) => AIChatProvider()),
      ],
      child: MaterialApp(
        title: 'Web Builder - Drag & Drop with AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const BuilderScreen(),
      ),
    );
  }
}
