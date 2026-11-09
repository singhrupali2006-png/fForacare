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

  DateTime get nextWatering => lastWatered.add(Duration(days: wateringIntervalDays));

  /// Whole days until the next watering. Negative when overdue.
  int get daysUntilWatering {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final n = nextWatering;
    final next = DateTime.utc(n.year, n.month, n.day);
    return next.difference(today).inDays;
  }

  bool get needsWater => daysUntilWatering <= 0;

  String get statusLabel {
    final d = daysUntilWatering;
    if (d < -1) return 'Overdue by ${-d} days';
    if (d == -1) return 'Overdue by 1 day';
    if (d == 0) return 'Water today';
    if (d == 1) return 'Water tomorrow';
    return 'Water in $d days';
  }

  Plant copyWith({
    String? name,
    String? species,
    String? location,
    int? wateringIntervalDays,
    DateTime? lastWatered,
    Sunlight? sunlight,
    String? notes,
  }) {
    return Plant(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      location: location ?? this.location,
      wateringIntervalDays: wateringIntervalDays ?? this.wateringIntervalDays,
      lastWatered: lastWatered ?? this.lastWatered,
      sunlight: sunlight ?? this.sunlight,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'species': species,
        'location': location,
        'wateringIntervalDays': wateringIntervalDays,
        'lastWatered': lastWatered.toIso8601String(),
        'sunlight': sunlight.name,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] as String,
      name: json['name'] as String,
      species: (json['species'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      wateringIntervalDays: (json['wateringIntervalDays'] as num?)?.toInt() ?? 7,
      lastWatered: DateTime.parse(json['lastWatered'] as String),
      sunlight: Sunlight.values.firstWhere(
        (s) => s.name == json['sunlight'],
        orElse: () => Sunlight.medium,
      ),
      notes: (json['notes'] as String?) ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
