import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/plant.dart';
import '../providers/plant_provider.dart';
import 'add_edit_plant_screen.dart';

class PlantDetailScreen extends StatelessWidget {
  final String plantId;
  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantProvider>();
    final plant = provider.byId(plantId);

    if (plant == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Plant not found')),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final df = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditPlantScreen(plant: plant)),
            ),
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, provider, plant),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 54,
              backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.local_florist, size: 56, color: scheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              plant.statusLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: plant.needsWater ? scheme.error : scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              provider.waterPlant(plant.id);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('${plant.name} watered 💧')));
            },
            icon: const Icon(Icons.water_drop),
            label: const Text('Mark as watered'),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
          const SizedBox(height: 24),
          _InfoTile(icon: Icons.science_outlined, label: 'Species', value: plant.species),
          _InfoTile(icon: Icons.place_outlined, label: 'Location', value: plant.location),
          _InfoTile(icon: Icons.wb_sunny_outlined, label: 'Sunlight', value: plant.sunlight.label),
          _InfoTile(icon: Icons.repeat, label: 'Watering schedule', value: 'Every ${plant.wateringIntervalDays} days'),
          _InfoTile(icon: Icons.history, label: 'Last watered', value: df.format(plant.lastWatered)),
          _InfoTile(icon: Icons.event_available, label: 'Next watering', value: df.format(plant.nextWatering)),
          _InfoTile(icon: Icons.notes, label: 'Notes', value: plant.notes),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, PlantProvider provider, Plant plant) async {
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${plant.name}?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await provider.deletePlant(plant.id);
      navigator.pop();
    }
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.bodySmall),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
