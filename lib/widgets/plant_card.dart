import 'package:flutter/material.dart';

import '../models/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onTap;
  final VoidCallback onWater;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.onWater,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final thirsty = plant.needsWater;
    final accent = thirsty ? scheme.error : scheme.primary;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: scheme.surfaceContainerHighest.withAlpha(110),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: accent.withAlpha(35),
                child: Icon(Icons.local_florist, color: accent, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (plant.species.isNotEmpty || plant.location.isNotEmpty)
                      Text(
                        [plant.species, plant.location]
                            .where((s) => s.isNotEmpty)
                            .join(' • '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.water_drop_outlined, size: 16, color: accent),
                        const SizedBox(width: 4),
                        Text(
                          plant.statusLabel,
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Mark as watered',
                onPressed: onWater,
                icon: const Icon(Icons.water_drop),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
