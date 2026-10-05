import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/presentation/game_screen.dart';
import '../../features/map/presentation/map_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/game/:levelId',
      name: 'game',
      builder: (context, state) {
        final levelId =
            int.tryParse(state.pathParameters['levelid'] ?? '1') ?? 1;
        return GameScreen(levelId: levelId);
      },
    ),
  ],
);
