import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hand_sign_cricket/screens/game_setup_screen.dart';
import 'package:hand_sign_cricket/screens/toss_screen.dart';

import '../themes/app_colors.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/sound_toggle.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _titleController,
      _menuController,
      _floatingController,
      _soundToggleController;
  late Animation<double> _titleScale,
      _titleOpacity,
      _menuOpacity,
      _menuScale,
      _floatingMovement,
      _soundToggleOpacity,
      _soundToggleScale;

  @override
  void initState() {
    super.initState();

    // Title Animation
    _titleController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _titleScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(
        CurvedAnimation(parent: _titleController, curve: Curves.elasticOut));

    _titleOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _titleController, curve: Curves.easeIn));

    _titleController.forward();

    // Menu Animation
    _menuController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _menuOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _menuController, curve: Curves.easeInOut));
    _menuScale = Tween(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _menuController, curve: Curves.elasticOut));

    Future.delayed(
        Duration(milliseconds: 700), () => _menuController.forward());

    // Floating Animation for Buttons and Icons
    _floatingController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3),
        reverseDuration: Duration(seconds: 3))
      ..repeat(reverse: true);
    _floatingMovement = Tween(begin: 0.0, end: 10.0).animate(
        CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));

    // Sound Toggle Animation
    _soundToggleController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _soundToggleOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _soundToggleController, curve: Curves.easeInOut));
    _soundToggleScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
        parent: _soundToggleController, curve: Curves.elasticOut));

    Future.delayed(
        Duration(milliseconds: 500), () => _soundToggleController.forward());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _menuController.dispose();
    _floatingController.dispose();
    _soundToggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Stack(
        children: [
          // Sound button (top-left)
          Positioned(
            top: 40,
            left: 10,
            child: AnimatedBuilder(
              animation: _soundToggleController,
              builder: (context, child) {
                return Opacity(
                  opacity: _soundToggleOpacity.value,
                  child: Transform.scale(
                    scale: _soundToggleScale.value,
                    child: SoundToggleButton(),
                  ),
                );
              },
            ),
          ),

          // Animated Title (Pop-In, Bounce, and Fade)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _titleController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _titleOpacity.value,
                    child: Transform.scale(
                      scale: _titleScale.value,
                      child: Text(
                        "HAND CRICKET🏏",
                        style: GoogleFonts.sixtyfour(
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Center Content (Menu Buttons & Icons)
          Center(
            child: Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 220), // Spacing between title and buttons
                  // Animated Menu Buttons
                  AnimatedBuilder(
                    animation: _menuController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _menuOpacity.value,
                        child: Transform.scale(
                          scale: _menuScale.value,
                          child: Column(
                            children: [
                              MenuButton(
                                text: "Single Player",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TossScreen()));
                                },
                                icon: Icons.person,
                              ),
                              MenuButton(
                                text: "Multiplayer",
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GameSetupScreen(
                                              isMultiplayer: true)));
                                },
                                icon: Icons.group,
                              ),
                              MenuButton(
                                text: "How to Play",
                                onTap: () {},
                                icon: Icons.help,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 70),
                  // Floating Animated Icons (GitHub & Rating)
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(10, _floatingMovement.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Open GitHub repo (Replace with actual link)
                              },
                              child: Image.asset(
                                "assets/icons/github.png",
                                width: 50,
                                height: 50,
                              ),
                            ),
                            SizedBox(width: 60),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => RatingDialog());
                              },
                              child: Icon(Icons.star,
                                  color: Colors.grey, size: 50),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable button widget with Floating Effect and Icon
class MenuButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;

  MenuButton({required this.text, required this.onTap, required this.icon});

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _buttonScale, _buttonOpacity;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        reverseDuration: Duration(seconds: 1));

    _buttonScale = Tween(begin: 0.8, end: 1.05).animate(
        CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut));
    _buttonOpacity = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut));

    _buttonController.forward();
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _buttonController,
          builder: (context, child) {
            return Opacity(
              opacity: _buttonOpacity.value,
              child: Transform.scale(
                scale: _buttonScale.value,
                child: Container(
                  width: 350,
                  height: 80,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.boxYellow,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 8),
                          blurRadius: 20)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: AppColors.textRed, size: 30),
                      SizedBox(width: 15),
                      Text(
                        widget.text,
                        style:
                            TextStyle(fontSize: 22, color: AppColors.textRed),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
