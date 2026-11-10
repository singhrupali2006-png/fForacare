import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/plant_provider.dart';
import '../widgets/plant_card.dart';
import 'add_edit_plant_screen.dart';
import 'plant_detail_screen.dart';
import 'tips_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[const _PlantsTab(), const TipsScreen()];
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco),
            SizedBox(width: 8),
            Text('FloraCare', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: const [_ThemeMenu()],
      ),
      body: pages[_index],
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditPlantScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add plant'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.yard_outlined), selectedIcon: Icon(Icons.yard), label: 'My plants'),
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), selectedIcon: Icon(Icons.lightbulb), label: 'Care tips'),
        ],
      ),
    );
  }
}

class _ThemeMenu extends StatelessWidget {
  const _ThemeMenu();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PlantProvider>();
    return PopupMenuButton<ThemeMode>(
      icon: const Icon(Icons.brightness_6_outlined),
      tooltip: 'Theme',
      onSelected: provider.setThemeMode,
      itemBuilder: (_) => const [
        PopupMenuItem(value: ThemeMode.system, child: Text('System default')),
        PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
        PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
      ],
    );
  }
}

class _PlantsTab extends StatelessWidget {
  const _PlantsTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantProvider>();
    final plants = provider.plants;

    if (plants.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.spa_outlined, size: 84, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text('No plants yet', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                'Tap "Add plant" to start tracking watering for your green friends.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final thirsty = provider.thirstyCount;
    return ListView(
      padding: const EdgeInsets.only(bottom: 96, top: 8),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
          child: Text(
            thirsty == 0
                ? 'All your plants are happy 🌿'
                : '$thirsty plant${thirsty == 1 ? '' : 's'} need${thirsty == 1 ? 's' : ''} water',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        for (final plant in plants)
          Dismissible(
            key: ValueKey(plant.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 28),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.delete_outline),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Delete ${plant.name}?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                      ],
                    ),
                  ) ??
                  false;
            },
            onDismissed: (_) => provider.deletePlant(plant.id),
            child: PlantCard(
              plant: plant,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlantDetailScreen(plantId: plant.id)),
              ),
              onWater: () {
                provider.waterPlant(plant.id);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text('${plant.name} watered 💧')));
              },
            ),
          ),
      ],
    );
  }
}
