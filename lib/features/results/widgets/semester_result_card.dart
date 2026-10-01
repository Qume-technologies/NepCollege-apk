import 'package:flutter/material.dart';

class SemesterResultCard extends StatelessWidget {
  final String title;
  final String gpa;
  final List<Map<String, dynamic>> results;

  const SemesterResultCard({
    super.key,
    required this.title,
    required this.gpa,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text('GPA: $gpa', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        tilePadding: EdgeInsets.zero,
        shape: const Border(),
        children: results.map((r) {
          final subject = r['subject_name']?.toString() ?? r['subject']?.toString() ?? 'Overall Grade';
          final grade = '${r['grade'] ?? 'N/A'} ${r['status'] != null ? '(${r['status']})' : ''}'.trim();
          final url = r['url']?.toString();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(subject, style: TextStyle(color: theme.hintColor))),
                    Text(grade, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                if (url != null && url.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.all(10),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                InteractiveViewer(
                                  child: Image.network(url, fit: BoxFit.contain, 
                                    errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white, size: 50)
                                  )
                                ),
                                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded, color: Colors.white))
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
                            child: const Text('View Document', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
