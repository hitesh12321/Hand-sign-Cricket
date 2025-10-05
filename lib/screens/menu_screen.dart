// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hand_sign_cricket/screens/toss_screen.dart';
import 'package:hand_sign_cricket/transitions/PageTransition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../themes/app_colors.dart';
import '../themes/app_fonts.dart';
import '../widgets/howtoplay.dart';
import '../widgets/rating_dialog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _titleController,
      _menuController,
      _floatingController;
  late Animation<double> _titleSlide,
      _menuOpacity,
      _buttonScale,
      _floatingMovement;

  final screenTransition = ScreenTransition();

  @override
  void initState() {
    super.initState();

    // Title Slide-in Animation
    _titleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _titleSlide = Tween(begin: -200.0, end: 10.0).animate(
        CurvedAnimation(parent: _titleController, curve: Curves.easeOut));

    // Menu Fade-in & Bounce Animation
    _menuController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _menuOpacity =
        CurvedAnimation(parent: _menuController, curve: Curves.easeInOut);
    _buttonScale = Tween(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _menuController, curve: Curves.elasticOut));

    // Floating Animation for Icons
    _floatingController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
        reverseDuration: Duration(seconds: 2))
      ..repeat(reverse: true);

    _floatingMovement = Tween(begin: 0.0, end: 20.0).animate(
        CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _menuController.forward();
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _menuController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Title
          AnimatedBuilder(
            animation: _titleSlide,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _titleSlide.value),
                child: child,
              );
            },
            child: Column(
              children: [
                Text(
                  "HAND CRICKET",
                  style: AppFonts.pressStart2p(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: AppColors.titleOrange,
                    shadows: [
                      Shadow(
                          blurRadius: 12.0,
                          color: AppColors.shadowBlack,
                          offset: Offset(5, 5)),
                      Shadow(
                          blurRadius: 1.0,
                          color: AppColors.darkShadow,
                          offset: Offset(-2, -3)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Animated Menu Buttons
          FadeTransition(
            opacity: _menuOpacity,
            child: Column(
              children: [
                AnimatedScaleButton(
                  text: "Single Player",
                  onTap: () {
                    Navigator.of(context)
                        .push(ScreenTransition.createRoute(TossScreen()));
                  },
                  icon: Icons.person,
                  scaleAnimation: _buttonScale,
                ),
                AnimatedScaleButton(
                  text: "Multiplayer",
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Dialog",
                      barrierColor: Colors.black54,
                      transitionDuration: Duration(milliseconds: 400),
                      pageBuilder: (context, anim1, anim2) {
                        return Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 350,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.dialogYellow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.shadowBlack, width: 3),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "🚀 We will bring this feature very soon! Stay tuned! 🎉",
                                    textAlign: TextAlign.center,
                                    style: AppFonts.main(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dialogBlack,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.dialogOrange,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'OK',
                                      style: AppFonts.main(
                                        fontSize: 30,
                                        color: AppColors.dialogBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return ScaleTransition(
                          scale: CurvedAnimation(
                            parent: anim1,
                            curve: Curves.elasticOut,
                          ),
                          child: FadeTransition(
                            opacity: anim1,
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                  icon: Icons.group,
                  scaleAnimation: _buttonScale,
                ),
                AnimatedScaleButton(
                  text: "How to Play",
                  onTap: () {
                    Play.showHowToPlayDialog(context);
                  },
                  icon: Icons.help,
                  scaleAnimation: _buttonScale,
                ),
              ],
            ),
          ),
          SizedBox(height: 50),

          // Floating Icons (GitHub & Rating)
          AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatingMovement.value),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    const url =
                        "https://github.com/aavvvacado/Hand-sign-Cricket";
                    launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  },
                  label: Row(
                    children: [
                      Image.asset(
                        "assets/icons/github.png",
                        width: 40,
                        height: 40,
                      ),
                      Text(" GitHub",
                          style: AppFonts.main(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.buttonTextBlue))
                    ],
                  ),
                ),
                SizedBox(width: 20),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                        context: context, builder: (_) => RatingDialog());
                  },
                  label: Text(
                    "Rate Us",
                    style: AppFonts.main(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonTextBlue),
                  ),
                  icon: Icon(
                    Icons.star_border,
                    color: AppColors.buttonTextBlue,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Animated Scale Button
class AnimatedScaleButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final Animation<double> scaleAnimation;

  const AnimatedScaleButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 320,
            height: 70,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.boxYellow,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowBlack,
                    offset: Offset(3, 3),
                    blurRadius: 7,
                    blurStyle: BlurStyle.solid)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 45, color: AppColors.buttonTextBlue),
                SizedBox(width: 15),
                Text(text,
                    style: AppFonts.main(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: AppColors.buttonTextBlue)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
