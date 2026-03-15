import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game/doctor_rescue_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DoctorRescueApp());
}

class DoctorRescueApp extends StatelessWidget {
  const DoctorRescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: GameWidget<DoctorRescueGame>.controlled(
            gameFactory: DoctorRescueGame.new,
            overlayBuilderMap: {
              'StartMenu': (_, game) => StartMenu(game: game),
              'GameOverMenu': (_, game) => GameOverMenu(game: game),
              'WinMenu': (_, game) => WinMenu(game: game),
            },
            initialActiveOverlays: const ['StartMenu'],
          ),
        ),
      ),
    );
  }
}

class StartMenu extends StatefulWidget {
  final DoctorRescueGame game;
  const StartMenu({super.key, required this.game});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final t = _controller.value;
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + (t * 2), -1),
                end: Alignment(1, 1 - (t * 2)),
                colors: const [
                  Color(0xFF0E4C92),
                  Color(0xFF1E88E5),
                  Color(0xFFB3E5FC),
                ],
              ),
            ),
            child: Stack(
              children: [
                ...List.generate(10, (i) {
                  final dx =
                      ((i * 83.0) + t * 300) % MediaQuery.of(context).size.width;
                  final dy = 80 + (i * 57.0) % 500;
                  return Positioned(
                    left: dx,
                    top: dy,
                    child: Container(
                      width: 18 + (i % 3) * 10,
                      height: 18 + (i % 3) * 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
                Center(
                  child: Container(
                    width: 440,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 24,
                          color: Colors.black26,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'DOCTOR RESCUE',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0E4C92),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Collect medicine, save patients, and survive virus waves.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Desktop: WASD / Arrows + Space\nMobile: Virtual joystick + Shoot button',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: widget.game.startGame,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            child: Text('Start Game'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GameOverMenu extends StatelessWidget {
  final DoctorRescueGame game;
  const GameOverMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Score: ${game.player.score}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Rescued: ${game.player.rescuedPatients}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Wave: ${game.wave}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: game.restartGame,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Text('Restart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WinMenu extends StatelessWidget {
  final DoctorRescueGame game;
  const WinMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black45,
      child: Center(
        child: Container(
          width: 430,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FFF9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'YOU WIN',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Final Score: ${game.player.score}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Patients Rescued: ${game.player.rescuedPatients}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: game.restartGame,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Text('Play Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}