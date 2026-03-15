import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'explosion_particle.dart';
import 'furniture_block.dart';
import 'heal_powerup.dart';
import 'healing_particle.dart';
import 'medicine.dart';
import 'patient.dart';
import 'player.dart';
import 'syringe.dart';
import 'virus.dart';

class JoystickCircle extends PositionComponent {
  final double radius;
  final Paint paintStyle;

  JoystickCircle({
    required this.radius,
    required this.paintStyle,
  }) : super(size: Vector2.all(radius * 2));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(Offset(radius, radius), radius, paintStyle);
  }
}

class DoctorRescueGame extends FlameGame with KeyboardEvents, TapCallbacks {
  late Player player;
  late JoystickComponent joystick;

  final Random random = Random();

  final List<Virus> viruses = [];
  final List<Medicine> medicines = [];
  final List<Patient> patients = [];
  final List<Syringe> syringes = [];
  final List<FurnitureBlock> furnitureBlocks = [];
  final List<HealPowerup> healPowerups = [];

  double virusDamageCooldown = 0;
  double shootCooldown = 0;
  double waveBannerTimer = 0;

  bool isGameOver = false;
  bool isStarted = false;
  bool isWon = false;

  int wave = 1;
  final int maxWaves = 5;
  int missionTarget = 2;

  static const double worldWidth = 900;
  static const double worldHeight = 700;
  static const double headerHeight = 120;

  bool keyLeft = false;
  bool keyRight = false;
  bool keyUp = false;
  bool keyDown = false;

  @override
  Color backgroundColor() => const Color(0xFFEAF7FF);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    joystick = JoystickComponent(
      knob: JoystickCircle(
        radius: 24,
        paintStyle: Paint()..color = const Color(0xCC64B5F6),
      ),
      background: JoystickCircle(
        radius: 46,
        paintStyle: Paint()..color = const Color(0x553F51B5),
      ),
      margin: const EdgeInsets.only(left: 28, bottom: 28),
      priority: 1000,
    );

    add(joystick);
    pauseEngine();
  }

  void startGame() {
    overlays.remove('StartMenu');
    overlays.remove('GameOverMenu');
    overlays.remove('WinMenu');

    isStarted = true;
    isGameOver = false;
    isWon = false;
    wave = 1;
    missionTarget = 2;
    virusDamageCooldown = 0;
    shootCooldown = 0;
    waveBannerTimer = 2.0;

    keyLeft = false;
    keyRight = false;
    keyUp = false;
    keyDown = false;

    _clearWorld();
    _setupWorld();

    resumeEngine();
  }

  void restartGame() {
    startGame();
  }

  void _setupWorld() {
    player = Player();
    add(player);

    _addFurnitureBlocks();
    spawnWave();
  }

  void _addFurnitureBlocks() {
    final blocks = <FurnitureBlock>[
      FurnitureBlock(position: Vector2(70, 180), size: Vector2(180, 80)),
      FurnitureBlock(
        position: Vector2(worldWidth - 250, 180),
        size: Vector2(180, 80),
      ),
      FurnitureBlock(position: Vector2(70, 440), size: Vector2(180, 80)),
      FurnitureBlock(
        position: Vector2(worldWidth - 250, 440),
        size: Vector2(180, 80),
      ),
      FurnitureBlock(position: Vector2(90, 55), size: Vector2(120, 54)),
      FurnitureBlock(
        position: Vector2(worldWidth - 210, 55),
        size: Vector2(120, 54),
      ),
    ];

    for (final block in blocks) {
      furnitureBlocks.add(block);
      add(block);
    }
  }

  void _clearWorld() {
    for (final virus in List<Virus>.from(viruses)) {
      virus.removeFromParent();
    }
    viruses.clear();

    for (final medicine in List<Medicine>.from(medicines)) {
      medicine.removeFromParent();
    }
    medicines.clear();

    for (final patient in List<Patient>.from(patients)) {
      patient.removeFromParent();
    }
    patients.clear();

    for (final syringe in List<Syringe>.from(syringes)) {
      syringe.removeFromParent();
    }
    syringes.clear();

    for (final block in List<FurnitureBlock>.from(furnitureBlocks)) {
      block.removeFromParent();
    }
    furnitureBlocks.clear();

    for (final powerup in List<HealPowerup>.from(healPowerups)) {
      powerup.removeFromParent();
    }
    healPowerups.clear();

    for (final p in children.whereType<Player>().toList()) {
      p.removeFromParent();
    }
  }

  void spawnWave() {
    final virusCount = 2 + wave;
    final medicineCount = missionTarget;
    final patientCount = missionTarget;
    final virusSpeedMultiplier = 1.0 + (wave - 1) * 0.18;

    spawnViruses(virusCount, virusSpeedMultiplier);
    spawnMedicines(medicineCount);
    spawnPatients(patientCount);

    if (wave % 2 == 0) {
      spawnHealPowerup();
    }
  }

  void advanceWave() {
    wave += 1;
    missionTarget = min(5, 2 + (wave - 1));
    waveBannerTimer = 2.0;

    if (wave > maxWaves) {
      winGame();
      return;
    }

    spawnWave();
  }

  void winGame() {
    isWon = true;
    pauseEngine();
    overlays.add('WinMenu');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isStarted || isGameOver || isWon) return;

    final joy = joystick.relativeDelta;
    final joyLeft = joy.x < -0.12;
    final joyRight = joy.x > 0.12;
    final joyUp = joy.y < -0.12;
    final joyDown = joy.y > 0.12;

    player.moveLeft = keyLeft || joyLeft;
    player.moveRight = keyRight || joyRight;
    player.moveUp = keyUp || joyUp;
    player.moveDown = keyDown || joyDown;

    final previousPosition = player.position.clone();

    if (virusDamageCooldown > 0) virusDamageCooldown -= dt;
    if (shootCooldown > 0) shootCooldown -= dt;
    if (waveBannerTimer > 0) waveBannerTimer -= dt;

    resolvePlayerFurnitureCollision(previousPosition);
    checkVirusCollisions();
    checkMedicinePickups();
    checkPatientDelivery();
    checkHealPowerups();
    checkSyringeVirusHits();
    cleanupRemovedComponents();

    final remainingPatients =
        patients.where((p) => p.parent != null && !p.rescued).length;

    if (remainingPatients == 0 && !isGameOver && !isWon) {
      advanceWave();
    }

    if (player.health <= 0) {
      isGameOver = true;
      pauseEngine();
      overlays.add('GameOverMenu');
    }
  }

  void resolvePlayerFurnitureCollision(Vector2 previousPosition) {
    for (final block in furnitureBlocks) {
      if (player.hitbox.overlaps(block.hitbox)) {
        player.position = previousPosition;
        break;
      }
    }
  }

  void spawnViruses(int count, double speedMultiplier) {
    for (int i = 0; i < count; i++) {
      final virus = Virus(
        position: Vector2(
          random.nextDouble() * (worldWidth - 120) + 40,
          random.nextDouble() * (worldHeight - headerHeight - 120) +
              headerHeight +
              30,
        ),
        speedMultiplier: speedMultiplier,
      );
      viruses.add(virus);
      add(virus);
    }
  }

  void spawnMedicines(int count) {
    for (int i = 0; i < count; i++) {
      final medicine = Medicine(
        position: Vector2(
          random.nextDouble() * (worldWidth - 120) + 40,
          random.nextDouble() * (worldHeight - headerHeight - 120) +
              headerHeight +
              30,
        ),
      );
      medicines.add(medicine);
      add(medicine);
    }
  }

  void spawnPatients(int count) {
    for (int i = 0; i < count; i++) {
      final patient = Patient(
        position: Vector2(
          random.nextDouble() * (worldWidth - 180) + 70,
          random.nextDouble() * (worldHeight - headerHeight - 160) +
              headerHeight +
              40,
        ),
      );
      patients.add(patient);
      add(patient);
    }
  }

  void spawnHealPowerup() {
    final powerup = HealPowerup(
      position: Vector2(
        random.nextDouble() * (worldWidth - 120) + 40,
        random.nextDouble() * (worldHeight - headerHeight - 120) +
            headerHeight +
            30,
      ),
    );
    healPowerups.add(powerup);
    add(powerup);
  }

  void shootSyringe() {
    if (!isStarted || isGameOver || isWon) return;
    if (shootCooldown > 0) return;

    Vector2 dir = player.facing.clone();
    if (dir.length == 0) {
      dir = Vector2(1, 0);
    } else {
      dir.normalize();
    }

    final syringe = Syringe(
      position: player.centerPoint.clone(),
      direction: dir,
    );

    syringes.add(syringe);
    add(syringe);

    shootCooldown = 0.28;
  }

  void checkVirusCollisions() {
    for (final virus in viruses) {
      if (virus.parent == null) continue;

      if (player.hitbox.overlaps(virus.hitbox) && virusDamageCooldown <= 0) {
        player.health -= 1;
        virusDamageCooldown = 0.9;
        virus.triggerHitFlash();
      }
    }
  }

  void checkMedicinePickups() {
    if (player.carryingMedicine) return;

    for (final medicine in List<Medicine>.from(medicines)) {
      if (medicine.parent != null && player.hitbox.overlaps(medicine.hitbox)) {
        player.carryingMedicine = true;
        player.score += 10;
        medicine.removeFromParent();
        medicines.remove(medicine);
        break;
      }
    }
  }

  void checkPatientDelivery() {
    if (!player.carryingMedicine) return;

    for (final patient in patients) {
      if (patient.parent != null &&
          !patient.rescued &&
          player.hitbox.overlaps(patient.hitbox)) {
        patient.heal();
        player.carryingMedicine = false;
        player.rescuedPatients += 1;
        player.score += 30;

        final rescuedCenter = Vector2(
          patient.position.x + patient.size.x / 2,
          patient.position.y + patient.size.y / 2,
        );

        final nearbyViruses = viruses.where((virus) {
          if (virus.parent == null) return false;
          final virusCenter = Vector2(
            virus.position.x + virus.size.x / 2,
            virus.position.y + virus.size.y / 2,
          );
          return (virusCenter - rescuedCenter).length < 120;
        }).toList();

        for (final virus in nearbyViruses) {
          final center = Vector2(
            virus.position.x + virus.size.x / 2,
            virus.position.y + virus.size.y / 2,
          );

          for (final particle in ExplosionParticle.burst(center)) {
            add(particle);
          }

          virus.removeFromParent();
          viruses.remove(virus);
          player.score += 20;
        }

        break;
      }
    }
  }

  void checkHealPowerups() {
    for (final powerup in List<HealPowerup>.from(healPowerups)) {
      if (powerup.parent != null && player.hitbox.overlaps(powerup.hitbox)) {
        player.health = min(5, player.health + 2);
        player.score += 10;

        for (final particle in HealingParticle.around(player.centerPoint)) {
          add(particle);
        }

        powerup.removeFromParent();
        healPowerups.remove(powerup);
      }
    }
  }

  void checkSyringeVirusHits() {
    final virusesToRemove = <Virus>{};
    final syringesToRemove = <Syringe>{};

    for (final syringe in syringes) {
      if (syringe.parent == null) continue;

      for (final virus in viruses) {
        if (virus.parent == null) continue;

        if (syringe.hitbox.overlaps(virus.hitbox)) {
          virus.triggerHitFlash();
          virusesToRemove.add(virus);
          syringesToRemove.add(syringe);
          player.score += 15;
        }
      }
    }

    for (final virus in virusesToRemove) {
      final center = Vector2(
        virus.position.x + virus.size.x / 2,
        virus.position.y + virus.size.y / 2,
      );

      for (final particle in ExplosionParticle.burst(center)) {
        add(particle);
      }

      virus.removeFromParent();
      viruses.remove(virus);
    }

    for (final syringe in syringesToRemove) {
      syringe.removeFromParent();
      syringes.remove(syringe);
    }
  }

  void cleanupRemovedComponents() {
    syringes.removeWhere((s) => s.parent == null);
    medicines.removeWhere((m) => m.parent == null);
    patients.removeWhere((p) => p.parent == null);
    viruses.removeWhere((v) => v.parent == null);
    healPowerups.removeWhere((p) => p.parent == null);
  }

  @override
  void render(Canvas canvas) {
    _drawHospitalBackground(canvas);
    super.render(canvas);

    if (isStarted && !isGameOver && !isWon) {
      const style = TextStyle(
        color: Colors.black87,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      );

      final remainingPatients =
          patients.where((p) => p.parent != null && !p.rescued).length;

      _paintText(canvas, 'Health: ${player.health}', const Offset(22, 22), style);
      _paintText(canvas, 'Score: ${player.score}', const Offset(22, 52), style);
      _paintText(canvas, 'Wave: $wave / $maxWaves', const Offset(22, 82), style);

      _paintText(
        canvas,
        'Mission: rescue $remainingPatients / $missionTarget patient(s)',
        const Offset(250, 22),
        const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );

      _paintText(
        canvas,
        player.carryingMedicine ? 'Carrying: Medicine' : 'Carrying: Nothing',
        const Offset(250, 52),
        const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );

      _paintText(
        canvas,
        'Space or button = shoot',
        const Offset(250, 82),
        const TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      );

      if (waveBannerTimer > 0) {
        final opacity = (waveBannerTimer / 2.0).clamp(0.0, 1.0);

        final bannerPainter = TextPainter(
          text: TextSpan(
            text: 'WAVE $wave',
            style: TextStyle(
              color: Colors.blue.shade900.withOpacity(opacity),
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        bannerPainter.paint(
          canvas,
          Offset(size.x / 2 - bannerPainter.width / 2, 130),
        );
      }

      _drawShootButton(canvas);
    }
  }

  void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  void _drawShootButton(Canvas canvas) {
    final center = Offset(size.x - 90, size.y - 90);
    canvas.drawCircle(center, 46, Paint()..color = const Color(0x553F51B5));
    canvas.drawCircle(center, 36, Paint()..color = const Color(0xFF1976D2));

    final tp = TextPainter(
      text: const TextSpan(
        text: 'SHOT',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  bool _pressedShootArea(Offset p) {
    final center = Offset(size.x - 90, size.y - 90);
    final dx = p.dx - center.dx;
    final dy = p.dy - center.dy;
    return dx * dx + dy * dy <= 46 * 46;
  }

  void _drawHospitalBackground(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFFF4FBFF),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, headerHeight),
      Paint()..color = const Color(0xFFD8EEF9),
    );

    canvas.drawRect(
      Rect.fromLTWH(0, headerHeight, size.x, size.y - headerHeight),
      Paint()..color = const Color(0xFFF9FDFF),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFD8EAF2)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.x; x += 60) {
      canvas.drawLine(Offset(x, headerHeight), Offset(x, size.y), gridPaint);
    }

    for (double y = headerHeight; y <= size.y; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }

    _drawBed(canvas, const Offset(70, 180));
    _drawBed(canvas, Offset(size.x - 250, 180));
    _drawBed(canvas, const Offset(70, 440));
    _drawBed(canvas, Offset(size.x - 250, 440));

    _drawCabinet(canvas, const Offset(90, 55));
    _drawCabinet(canvas, Offset(size.x - 210, 55));
  }

  void _drawBed(Canvas canvas, Offset offset) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx, offset.dy, 180, 80),
        const Radius.circular(14),
      ),
      Paint()..color = const Color(0xFFBBE3F8),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + 12, offset.dy + 12, 44, 24),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.white,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx + 60, offset.dy + 18, 72, 38),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFDFF2FD),
    );
  }

  void _drawCabinet(Canvas canvas, Offset offset) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(offset.dx, offset.dy, 120, 54),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.white,
    );

    final linePaint = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(offset.dx + 60, offset.dy + 8),
      Offset(offset.dx + 60, offset.dy + 46),
      linePaint,
    );
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!isStarted || isGameOver || isWon) {
      return KeyEventResult.handled;
    }

    keyLeft =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);

    keyRight =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    keyUp =
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);

    keyDown =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);

    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space) {
      shootSyringe();
    }

    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isStarted || isGameOver || isWon) return;

    if (_pressedShootArea(event.canvasPosition.toOffset())) {
      shootSyringe();
    }
  }
}