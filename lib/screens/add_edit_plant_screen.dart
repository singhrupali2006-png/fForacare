import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/plant.dart';
import '../providers/plant_provider.dart';

class AddEditPlantScreen extends StatefulWidget {
  /// When provided, the screen edits this plant; otherwise it creates a new one.
  final Plant? plant;
  const AddEditPlantScreen({super.key, this.plant});

  @override
  State<AddEditPlantScreen> createState() => _AddEditPlantScreenState();
}

class _AddEditPlantScreenState extends State<AddEditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _species;
  late final TextEditingController _location;
  late final TextEditingController _notes;
  late int _interval;
  late DateTime _lastWatered;
  late Sunlight _sunlight;

  bool get _isEditing => widget.plant != null;

  @override
  void initState() {
    super.initState();
    final p = widget.plant;
    _name = TextEditingController(text: p?.name ?? '');
    _species = TextEditingController(text: p?.species ?? '');
    _location = TextEditingController(text: p?.location ?? '');
    _notes = TextEditingController(text: p?.notes ?? '');
    _interval = p?.wateringIntervalDays ?? 7;
    _lastWatered = p?.lastWatered ?? DateTime.now();
    _sunlight = p?.sunlight ?? Sunlight.medium;
  }

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastWatered,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _lastWatered = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<PlantProvider>();
    final navigator = Navigator.of(context);

    if (_isEditing) {
      await provider.updatePlant(widget.plant!.copyWith(
        name: _name.text.trim(),
        species: _species.text.trim(),
        location: _location.text.trim(),
        wateringIntervalDays: _interval,
        lastWatered: _lastWatered,
        sunlight: _sunlight,
        notes: _notes.text.trim(),
      ));
    } else {
      await provider.addPlant(
        name: _name.text.trim(),
        species: _species.text.trim(),
        location: _location.text.trim(),
        wateringIntervalDays: _interval,
        lastWatered: _lastWatered,
        sunlight: _sunlight,
        notes: _notes.text.trim(),
      );
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit plant' : 'Add plant')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Plant name *', prefixIcon: Icon(Icons.local_florist)),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _species,
              decoration: const InputDecoration(labelText: 'Species (optional)', prefixIcon: Icon(Icons.science_outlined)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _location,
              decoration: const InputDecoration(labelText: 'Location (optional)', prefixIcon: Icon(Icons.place_outlined)),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Sunlight>(
              value: _sunlight,
              decoration: const InputDecoration(labelText: 'Sunlight', prefixIcon: Icon(Icons.wb_sunny_outlined)),
              items: [
                for (final s in Sunlight.values) DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (s) => setState(() => _sunlight = s ?? _sunlight),
            ),
            const SizedBox(height: 20),
            Text('Water every $_interval day${_interval == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleSmall),
            Slider(
              value: _interval.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$_interval',
              onChanged: (v) => setState(() => _interval = v.round()),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: const Text('Last watered'),
              subtitle: Text(DateFormat.yMMMd().format(_lastWatered)),
              trailing: const Icon(Icons.edit_calendar_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notes,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Notes (optional)', alignLabelWithHint: true),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check),
              label: Text(_isEditing ? 'Save changes' : 'Add plant'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            ),
          ],
        ),
      ),
    );
  }
}
