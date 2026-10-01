import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<String> _preferences = [
    'Budget',
    'Rating',
    'Fast Delivery',
    'Features',
  ];
  String _selectedPreference = 'Budget';

  @override
  void initState() {
    super.initState();
    final current = AuthService.instance.currentUser;
    if (current != null) {
      _selectedPreference = current.preference;
    }
  }

  Future<void> _savePreference() async {
    AuthService.instance.updatePreference(_selectedPreference);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Shopping preference saved.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select what matters most while shopping.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _preferences.map((preference) {
                final isSelected = _selectedPreference == preference;
                return ChoiceChip(
                  label: Text(preference),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedPreference = preference;
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _savePreference,
              child: const Text('Save Preference'),
            ),
          ],
        ),
      ),
    );
  }
}
