import 'package:flutter/material.dart';

import '../models/plant.dart';
import '../services/plant_storage.dart';

class PlantProvider extends ChangeNotifier {
  final PlantStorage _storage;
  PlantProvider(this._storage);

  List<Plant> _plants = [];
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  /// Plants sorted by how soon they need water.
  List<Plant> get plants {
    final copy = [..._plants];
    copy.sort((a, b) => a.daysUntilWatering.compareTo(b.daysUntilWatering));
    return copy;
  }

  int get thirstyCount => _plants.where((p) => p.needsWater).length;

  Plant? byId(String id) {
    for (final p in _plants) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> load() async {
    _plants = await _storage.loadPlants();
    final theme = await _storage.loadTheme();
    _themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == theme,
      orElse: () => ThemeMode.system,
    );
    notifyListeners();
  }

  Future<void> addPlant({
    required String name,
    String species = '',
    String location = '',
    required int wateringIntervalDays,
    required DateTime lastWatered,
    Sunlight sunlight = Sunlight.medium,
    String notes = '',
  }) async {
    final now = DateTime.now();
    _plants.add(Plant(
      id: now.microsecondsSinceEpoch.toString(),
      name: name,
      species: species,
      location: location,
      wateringIntervalDays: wateringIntervalDays,
      lastWatered: lastWatered,
      sunlight: sunlight,
      notes: notes,
      createdAt: now,
    ));
    await _persist();
  }

  Future<void> updatePlant(Plant updated) async {
    final i = _plants.indexWhere((p) => p.id == updated.id);
    if (i == -1) return;
    _plants[i] = updated;
    await _persist();
  }

  Future<void> deletePlant(String id) async {
    _plants.removeWhere((p) => p.id == id);
    await _persist();
  }

  Future<void> waterPlant(String id) async {
    final plant = byId(id);
    if (plant == null) return;
    await updatePlant(plant.copyWith(lastWatered: DateTime.now()));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _storage.saveTheme(mode.name);
  }

  Future<void> _persist() async {
    notifyListeners();
    await _storage.savePlants(_plants);
  }
}
