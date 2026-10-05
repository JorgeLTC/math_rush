import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Level Select'),
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () =>
              context.pushNamed('game', pathParameters: {'levelId': '1'}),
          label: const Text('Start Level 1'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
