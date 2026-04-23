import 'package:flutter/material.dart';

class ZoneDivider extends StatelessWidget {
  final String title;
  final Color color;

  const ZoneDivider({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: color, thickness: 2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(child: Divider(color: color, thickness: 2)),
        ],
      ),
    );
  }
}