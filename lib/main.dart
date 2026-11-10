import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/plant_provider.dart';
import 'services/plant_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = PlantProvider(PlantStorage());
  await provider.load();
  runApp(
    ChangeNotifierProvider<PlantProvider>.value(
      value: provider,
      child: const FloraCareApp(),
    ),
  );
}
