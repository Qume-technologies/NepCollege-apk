import 'package:flutter/material.dart';
import '../widgets/campus_map_placeholder.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMPUS MAP'),
        centerTitle: true,
      ),
      body: const Center(
        child: CampusMapPlaceholder(),
      ),
    );
  }
}
