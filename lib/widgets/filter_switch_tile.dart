import 'package:flutter/material.dart';

class FilterSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const FilterSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      secondary: CircleAvatar(
        backgroundColor:
        Theme.of(context).colorScheme.primary.withOpacity(0.15),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      value: value,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: onChanged,
    );
  }
}