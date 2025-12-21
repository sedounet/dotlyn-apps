import 'package:flutter/material.dart';

class TimestampList extends StatelessWidget {
  final List<Map<String, String>> entries;
  const TimestampList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        return ListTile(
          leading: const Icon(Icons.check),
          title: Text('${entry['step']} - ${entry['time']}'),
        );
      },
    );
  }
}
