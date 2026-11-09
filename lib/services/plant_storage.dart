import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant.dart';

/// Persists plants locally as JSON using shared_preferences.
class PlantStorage {
  static const _plantsKey = 'floracare_plants';
  static const _themeKey = 'floracare_theme';

  Future<List<Plant>> loadPlants() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_plantsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Plant.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePlants(List<Plant> plants) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_plantsKey, jsonEncode(plants.map((p) => p.toJson()).toList()));
  }

  Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  Future<void> saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }
}
