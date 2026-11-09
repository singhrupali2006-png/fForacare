enum Sunlight { low, medium, bright, direct }

extension SunlightX on Sunlight {
  String get label {
    switch (this) {
      case Sunlight.low:
        return 'Low light';
      case Sunlight.medium:
        return 'Medium light';
      case Sunlight.bright:
        return 'Bright indirect';
      case Sunlight.direct:
        return 'Direct sun';
    }
  }
}

class Plant {
  final String id;
  final String name;
  final String species;
  final String location;
  final int wateringIntervalDays;
  final DateTime lastWatered;
  final Sunlight sunlight;
  final String notes;
  final DateTime createdAt;

  const Plant({
    required this.id,
    required this.name,
    this.species = '',
    this.location = '',
    required this.wateringIntervalDays,
    required this.lastWatered,
    this.sunlight = Sunlight.medium,
    this.notes = '',
    required this.createdAt,
  });
}
