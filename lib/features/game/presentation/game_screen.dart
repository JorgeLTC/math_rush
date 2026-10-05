import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game_loop/presentation/game_notifier.dart';

class GameScreen extends ConsumerWidget {
  final int levelId;

  const GameScreen({super.key, required this.levelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider(levelId));
    final notifier = ref.read(gameNotifierProvider(levelId).notifier);

    const primaryDark = Color(0xFF121212);
    const surfaceDark = Color(0xFF1E1E1E);
    const accentNeon = Color(0xFF00E676);
    const accentDanger = Color(0xFFFF1744);

    final timerProgress =
        (gameState.currentTimeRemaining / gameState.maxTimeSeconds)
            .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top HUD
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (index) {
                      final hasHeart = index < gameState.remainingHearts;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Icon(
                          hasHeart ? Icons.favorite : Icons.favorite_border,
                          color: hasHeart ? accentDanger : Colors.white24,
                          size: 26,
                        ),
                      );
                    }),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      'Table ×${gameState.selectedTable}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: gameState.streak > 0
                              ? accentNeon
                              : Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.bolt,
                            color: gameState.streak > 0
                                ? accentNeon
                                : Colors.white38,
                            size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.streak}',
                          style: TextStyle(
                            color: gameState.streak > 0
                                ? accentNeon
                                : Colors.white38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. High-Stakes Timer Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    height: 8,
                    width: MediaQuery.of(context).size.width * timerProgress,
                    decoration: BoxDecoration(
                      color: timerProgress < 0.3 ? accentDanger : accentNeon,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (timerProgress < 0.3 ? accentDanger : accentNeon)
                                  .withOpacity(0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 3. Question Display
            Text(
              '${gameState.factorA} × ${gameState.factorB}',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),

            const Spacer(),

            // 4. 2x2 Multiple Choice Button Grid
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                ),
                itemCount: gameState.options.length,
                itemBuilder: (context, index) {
                  final optionValue = gameState.options[index];

                  return InkWell(
                    onTap: () => notifier.submitAnswer(optionValue),
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: surfaceDark,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$optionValue',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
