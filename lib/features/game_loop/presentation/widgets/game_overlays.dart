import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final int streak;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const GameOverOverlay({
    super.key,
    required this.streak,
    required this.onRetry,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    const surfaceDark = Color(0xFF1E1E1E);
    const accentDanger = Color(0xFFFF1244);

    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentDanger, width: 2),
            boxShadow: [
              BoxShadow(
                color: accentDanger.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.heart_broken_rounded,
                color: accentDanger,
                size: 64,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'TIME OVER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Highest Streak: $streak',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(
                height: 28,
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentDanger,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onRetry,
                  child: const Text(
                    'TRY AGAIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                    onPressed: onExit,
                    child: const Text(
                      'Back to Map',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VictoryOverlay extends StatelessWidget {
  final int levelId;
  final VoidCallback onNextLevel;
  final VoidCallback onExit;

  const VictoryOverlay({
    super.key,
    required this.levelId,
    required this.onNextLevel,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    const surfaceDark = Color(0xFF1E1E1E);
    const accentNeon = Color(0xFF00E676);

    return Container(
      color: Colors.black87,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          padding: const EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            color: surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentNeon, width: 2),
            boxShadow: [
              BoxShadow(
                color: accentNeon.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded,
                  color: accentNeon, size: 64),
              const SizedBox(height: 16),
              const Text(
                'LEVEL CLEARED!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Table ×$levelId Mastered',
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentNeon,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: onNextLevel,
                  child: const Text(
                    'NEXT LEVEL',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onExit,
                  child: const Text(
                    'Back to Map',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
