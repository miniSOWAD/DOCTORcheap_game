
# 🩺 DOCTOR RESCUE

<p align="center">
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0ea5e9,50:22c55e,100:f472b6&height=220&section=header&text=DOCTOR%20RESCUE&fontSize=48&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Futuristic%20Medical%20Rescue%20Game%20Built%20with%20Flutter%20and%20Flame&descAlignY=60"/>
</p>

<p align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Flame Engine](https://img.shields.io/badge/Engine-Flame-orange)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Mobile-green)
![Game](https://img.shields.io/badge/Genre-2D%20Action%20Rescue-red)

</p>

---

# 🚀 About The Project

**Doctor Rescue** is a **2D action‑rescue game** built using **Flutter** and the **Flame Game Engine**.

You play as a doctor inside a hospital experiencing a viral outbreak. Your mission is to:

- 💊 Collect medicine
- 🧑‍⚕️ Rescue infected patients
- 💉 Destroy viruses with syringes
- 🌊 Survive escalating waves of infection

The project demonstrates **game architecture, AI behavior, particle effects, collision systems, and cross‑platform gameplay** using Flutter.

---

# 🎮 Gameplay

The gameplay loop focuses on strategy and movement.

1. Start inside a hospital ward
2. Collect medicine pickups
3. Deliver medicine to patients
4. Avoid or destroy viruses
5. Survive increasing waves

Rescuing patients can **purify nearby viruses**, rewarding smart gameplay decisions.

---

# ✨ Features

## 🧑‍⚕️ Player System

- Smooth doctor movement
- Keyboard + mobile joystick controls
- Health and score system
- Medicine carrying mechanic

---

## 🦠 Virus AI

Viruses feature:

- Random roaming movement
- Chase behavior when near the player
- Collision damage system
- Hit flash effect
- Explosion particle effect

---

## 💉 Combat

The doctor fires **syringe projectiles**:

- Directional shooting
- Virus elimination
- Particle effects
- Score rewards

---

## 🌊 Wave System

Each wave increases difficulty through:

- More viruses
- Faster enemies
- Higher mission targets

A **wave banner animation** announces each new round.

---

## ⭐ Powerups

Healing powerups appear periodically and:

- Restore player health
- Trigger healing particle effects
- Help survive difficult waves

---

## 🏥 Interactive Environment

Hospital furniture acts as **collision obstacles**:

- Beds
- Cabinets
- Ward barriers

This adds **spatial strategy and movement challenge**.

---

# 🎮 Controls

## Desktop

| Action | Key |
|------|------|
Move | W A S D / Arrow Keys |
Shoot | Space |

## Mobile

| Action | Control |
|------|------|
Move | Virtual Joystick |
Shoot | On‑screen Shoot Button |

---

# 📊 HUD

The HUD displays:

- ❤️ Health
- ⭐ Score
- 🌊 Wave number
- 🎯 Mission progress
- 💊 Carrying state

---

# 🧱 Tech Stack

| Technology | Role |
|------|------|
Flutter | Cross‑platform framework |
Flame Engine | 2D game engine |
Dart | Programming language |
Canvas Rendering | Game visuals |
Overlay UI | Menus and HUD |

---

# 📂 Project Structure

```
lib/
│
├── main.dart
│
└── game/
    ├── doctor_rescue_game.dart
    ├── player.dart
    ├── virus.dart
    ├── patient.dart
    ├── medicine.dart
    ├── syringe.dart
    ├── furniture_block.dart
    ├── explosion_particle.dart
    ├── heal_powerup.dart
    └── healing_particle.dart
```

---

# ⚙️ Installation

### Clone the repository

```
git clone https://github.com/yourusername/doctor-rescue
cd doctor-rescue
```

### Install dependencies

```
flutter pub get
```

### Run the game

```
flutter run -d chrome
```

---

# 🎯 What This Project Demonstrates

- 2D game architecture
- Real‑time input handling
- Collision systems
- Particle effects
- Wave‑based enemy mechanics
- Cross‑platform gameplay

---

# 🔮 Future Improvements

Planned upgrades:

- Animated sprite sheets
- Boss virus enemies
- Sound effects and background music
- Multiple hospital maps
- Leaderboard system
- Difficulty modes
- Multiplayer rescue mode

---

# 👨‍💻 Author

**Md Mahruf Alam**

System Thinker • Problem Solver • Future Software Engineer

---

# ⭐ Support

If you like the project, consider giving it a **⭐ on GitHub**.

It helps others discover the game.

---

<p align="center">

### Heal the Hospital  
### Save the Patients  
### Defeat the Outbreak  

</p>
