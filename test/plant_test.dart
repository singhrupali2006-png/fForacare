import 'package:flutter_test/flutter_test.dart';
import 'package:floracare/models/plant.dart';

void main() {
  Plant make({required int interval, required DateTime last}) => Plant(
        id: '1',
        name: 'Monstera',
        wateringIntervalDays: interval,
        lastWatered: last,
        createdAt: DateTime.now(),
      );

  test('plant watered today with 7-day interval is due in 7 days', () {
    final p = make(interval: 7, last: DateTime.now());
    expect(p.daysUntilWatering, 7);
    expect(p.needsWater, false);
  });

  test('plant watered 10 days ago with 7-day interval is overdue', () {
    final p = make(interval: 7, last: DateTime.now().subtract(const Duration(days: 10)));
    expect(p.daysUntilWatering, -3);
    expect(p.needsWater, true);
    expect(p.statusLabel, 'Overdue by 3 days');
  });

  test('json round trip keeps values', () {
    final p = make(interval: 5, last: DateTime(2026, 1, 1)).copyWith(notes: 'Bright spot');
    final back = Plant.fromJson(p.toJson());
    expect(back.name, 'Monstera');
    expect(back.wateringIntervalDays, 5);
    expect(back.notes, 'Bright spot');
    expect(back.sunlight, Sunlight.medium);
  });
}
