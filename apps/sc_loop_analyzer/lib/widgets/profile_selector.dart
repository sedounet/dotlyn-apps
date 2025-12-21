import 'package:flutter/material.dart';

class ProfileSelector extends StatelessWidget {
  final List<String> profiles;
  final String selected;
  final ValueChanged<String?> onChanged;
  const ProfileSelector(
      {super.key, required this.profiles, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      items: profiles.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
      onChanged: onChanged,
    );
  }
}
