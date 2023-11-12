import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:useless/ui_library/styles.dart';
import 'dart:math' as math;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: Styles$Timings.slow,
    vsync: this,
  );

  late final titleOpacity = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: const Interval(0, 0.5)),
  );

  late final buttonOpacity = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1)),
  );

  bool componentTwoVisible = false;
  bool componentThreeVisible = false;

  @override
  void initState() {
    super.initState();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Column(
              children: [
                SizedBox(height: 50),
                FadeTransition(
                  opacity: titleOpacity,
                  child: Text(
                    'The most Useless App That Ever Existed',
                    style: Styles$Texts.xxxlNormal,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                AnimatedOpacity(
                  duration: Styles$Timings.base,
                  opacity: componentTwoVisible ? 1 : 0,
                  child: Text(
                    'What some fake people say about us',
                    style: Styles$Texts.baseNormal,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 170),
                AnimatedOpacity(
                  duration: Styles$Timings.base,
                  opacity: componentThreeVisible ? 1 : 0,
                  child: Transform.translate(
                    offset: Offset(-45, 0),
                    child: Transform.rotate(
                      angle: -math.pi / 12,
                      child: PersonCard(),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                AnimatedOpacity(
                  duration: Styles$Timings.base,
                  opacity: componentThreeVisible ? 1 : 0,
                  child: Transform.translate(
                    offset: Offset(80, 0),
                    child: Transform.rotate(
                      angle: math.pi / 12,
                      child: PersonCard(),
                    ),
                  ),
                ),
              ],
            ),
            FadeTransition(
              opacity: buttonOpacity,
              child: PrimaryButton(
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() {
    setState(() {
      if (!componentTwoVisible) {
        componentTwoVisible = true;
      } else if (!componentThreeVisible) {
        componentThreeVisible = true;
      }
    });
  }
}

class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 300,
      ),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 22),
      decoration: BoxDecoration(
        color: Styles$Colors.black100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Styles$Colors.black70,
            offset: Offset(0.0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, radius: 28),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Never wasted my time this hard before.',
              style:
                  Styles$Texts.smNormal.copyWith(color: Styles$Colors.white100),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool isTapped = false;

  void onTapDown(PointerDownEvent event) {
    setState(() {
      Future.delayed(Styles$Timings.superFast).then((value) {
        HapticFeedback.lightImpact();
        widget.onPressed();
      });
      isTapped = true;
    });
  }

  void onTapUp(PointerUpEvent event) {
    setState(() {
      isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) => onTapDown(details),
      onPointerUp: (details) => onTapUp(details),
      child: AnimatedContainer(
        duration: Styles$Timings.superFast,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          color: isTapped ? Styles$Colors.yellow600 : Styles$Colors.black100,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: isTapped ? Styles$Colors.yellow600 : Styles$Colors.black70,
              offset: Offset(0.0, isTapped ? 5 : 10),
              blurRadius: isTapped ? 10 : 20,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_right,
          size: 26,
          color: isTapped ? Styles$Colors.black100 : Styles$Colors.white100,
        ),
      ),
    );
  }
}
