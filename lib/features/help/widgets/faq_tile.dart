import 'package:flutter/material.dart';

class FaqTile extends StatelessWidget {
  final String q;
  final String a;

  const FaqTile({super.key, required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(q, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(a, style: TextStyle(fontSize: 13, color: theme.hintColor)),
          )
        ],
      ),
    );
  }
}
