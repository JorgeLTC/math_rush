import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameState {
  final int selectedTable;
  final int factorA;
  final int factorB;
  final List<int> options;
  final int streak;
  final int remainingHearts;
  final double maxTimeSeconds;
  final double currentTimeRemaining;
  final bool isGameOver;
  final bool isVictory;

  const GameState({
    required this.selectedTable,
    required this.factorA,
    required this.factorB,
    required this.options,
    required this.streak,
    required this.remainingHearts,
    required this.maxTimeSeconds,
    required this.currentTimeRemaining,
    required this.isGameOver,
    required this.isVictory,
  });

  int get correctAnswer => factorA * factorB;

  factory GameState.initial(int table) {
    final rng = math.Random();
    final initialB = rng.nextInt(10) + 1;
    final correct = table * initialB;

    return GameState(
      selectedTable: table,
      factorA: table,
      factorB: initialB,
      options: _generateOptions(correct, table),
      streak: 0,
      remainingHearts: 3,
      maxTimeSeconds: 5.0,
      currentTimeRemaining: 5.0,
      isGameOver: false,
      isVictory: false,
    );
  }

  GameState copyWith({
    int? factorA,
    int? factorB,
    List<int>? options,
    int? streak,
    int? remainingHearts,
    double? maxTimeSeconds,
    double? currentTimeRemaining,
    bool? isGameOver,
    bool? isVictory,
  }) {
    return GameState(
      selectedTable: selectedTable,
      factorA: factorA ?? this.factorA,
      factorB: factorB ?? this.factorB,
      options: options ?? this.options,
      streak: streak ?? this.streak,
      remainingHearts: remainingHearts ?? this.remainingHearts,
      maxTimeSeconds: maxTimeSeconds ?? this.maxTimeSeconds,
      currentTimeRemaining: currentTimeRemaining ?? this.currentTimeRemaining,
      isGameOver: isGameOver ?? this.isGameOver,
      isVictory: isVictory ?? this.isVictory,
    );
  }

  /// Generates 4 unique options (1 correct + 3 plausible distractors)
  static List<int> _generateOptions(int correct, int table) {
    final rng = math.Random();
    final Set<int> optionSet = {correct};

    while (optionSet.length < 4) {
      final offsets = [-table, table, -1, 1, -2, 2, 10, -10];
      final offset = offsets[rng.nextInt(offsets.length)];
      final candidate = correct + offset;

      if (candidate > 0 && candidate != correct) {
        optionSet.add(candidate);
      } else {
        optionSet.add(math.max(1, correct + rng.nextInt(12) - 6));
      }
    }

    final list = optionSet.toList();
    list.shuffle(rng);
    return list;
  }
}

class GameNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  static const double _timerTickInterval = 0.05;
  static const double _minTimeFloor = 1.2;

  GameNotifier(int table) : super(GameState.initial(table)) {
    _startTimer();
  }

  /// Generates a new random factor B that is guaranteed not to match the current factor B
  int _getRandomB(int currentB) {
    final rng = math.Random();
    int nextB;
    do {
      nextB = rng.nextInt(10) + 1;
    } while (
        nextB == currentB && 10 > 1); // Avoid immediate duplicate questions
    return nextB;
  }

  double _calculateNextTimerWindow(int currentStreak) {
    const double baseTime = 5.0;
    const double decayRate = 0.92;
    final double calculated =
        baseTime * math.pow(decayRate, currentStreak).toDouble();
    return math.max(calculated, _minTimeFloor);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        if (state.currentTimeRemaining <= 0) {
          _handleTimeout();
        } else {
          state = state.copyWith(
            currentTimeRemaining:
                state.currentTimeRemaining - _timerTickInterval,
          );
        }
      },
    );
  }

  bool submitAnswer(int selectedAnswer) {
    if (state.isGameOver || state.isVictory) return false;

    if (selectedAnswer == state.correctAnswer) {
      _handleCorrectAnswer();
      return true;
    } else {
      _handleWrongAnswer();
      return false;
    }
  }

  void _handleCorrectAnswer() {
    final newStreak = state.streak + 1;

    if (newStreak >= 15) {
      _timer?.cancel();
      state = state.copyWith(streak: newStreak, isVictory: true);
      return;
    }

    final nextTimer = _calculateNextTimerWindow(newStreak);
    final nextB = _getRandomB(state.factorB);
    final nextCorrect = state.selectedTable * nextB;

    state = state.copyWith(
      factorA: state.selectedTable,
      factorB: nextB,
      options: GameState._generateOptions(nextCorrect, state.selectedTable),
      streak: newStreak,
      maxTimeSeconds: nextTimer,
      currentTimeRemaining: nextTimer,
    );

    _startTimer();
  }

  void _handleWrongAnswer() {
    _applyDamage();
  }

  void _handleTimeout() {
    _applyDamage();
  }

  void _applyDamage() {
    final updatedHearts = state.remainingHearts - 1;

    if (updatedHearts <= 0) {
      _timer?.cancel();
      state = state.copyWith(
        remainingHearts: 0,
        currentTimeRemaining: 0,
        isGameOver: true,
      );
    } else {
      const double resetTimer = 5.0;
      final nextB = _getRandomB(state.factorB);
      final nextCorrect = state.selectedTable * nextB;

      state = state.copyWith(
        remainingHearts: updatedHearts,
        streak: 0,
        factorA: state.selectedTable,
        factorB: nextB,
        options: GameState._generateOptions(nextCorrect, state.selectedTable),
        maxTimeSeconds: resetTimer,
        currentTimeRemaining: resetTimer,
      );

      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final gameNotifierProvider = StateNotifierProvider.family
    .autoDispose<GameNotifier, GameState, int>((ref, table) {
  return GameNotifier(table);
});
