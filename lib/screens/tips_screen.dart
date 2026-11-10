import 'package:flutter/material.dart';

class _Tip {
  final IconData icon;
  final String title;
  final String body;
  const _Tip(this.icon, this.title, this.body);
}

const _tips = <_Tip>[
  _Tip(Icons.water_drop_outlined, 'Check the soil first',
      'Push a finger about 2 cm into the soil. If it feels dry, water; if damp, wait a day or two.'),
  _Tip(Icons.wb_sunny_outlined, 'Match light to the plant',
      'Succulents love bright light, while ferns and pothos are happier in low to medium light.'),
  _Tip(Icons.opacity, 'Avoid overwatering',
      'Overwatering is the most common cause of plant death. Always use pots with drainage holes.'),
  _Tip(Icons.thermostat, 'Keep temperatures steady',
      'Most houseplants prefer 18–27 °C and dislike cold drafts or hot air vents.'),
  _Tip(Icons.cleaning_services_outlined, 'Wipe the leaves',
      'Dust blocks light. Gently wipe leaves with a damp cloth every few weeks.'),
  _Tip(Icons.grass, 'Feed during growth',
      'Use a diluted balanced fertiliser every 4–6 weeks in spring and summer; pause in winter.'),
  _Tip(Icons.content_cut, 'Prune regularly',
      'Remove yellow or dead leaves to help the plant direct energy into healthy growth.'),
  _Tip(Icons.swap_vert, 'Rotate your plants',
      'Turn pots a quarter turn weekly so all sides get even light and grow straight.'),
];

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _tips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final tip = _tips[i];
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: scheme.surfaceContainerHighest.withAlpha(110),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(tip.icon, color: scheme.onPrimaryContainer),
            ),
            title: Text(tip.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(tip.body),
            ),
          ),
        );
      },
    );
  }
}
