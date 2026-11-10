import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/plant_provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

class FloraCareApp extends StatelessWidget {
  const FloraCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<PlantProvider, ThemeMode>((p) => p.themeMode);
    return MaterialApp(
      title: 'FloraCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
