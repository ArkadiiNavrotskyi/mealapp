import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Small helper that pops a burst of confetti in the center of the screen.
/// Usage:  ConfettiHelper.pop(context);
class ConfettiHelper {
  static void pop(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    final controller = ConfettiController(
      duration: const Duration(milliseconds: 900),
    );

    entry = OverlayEntry(
      builder: (_) => IgnorePointer(
        child: Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: controller,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 22,
            gravity: 0.35,
            emissionFrequency: 0.03,
            colors: const [
              Color(0xFFE85D04),
              Color(0xFFFFB300),
              Color(0xFFD81B60),
              Color(0xFF00ACC1),
              Color(0xFF43A047),
            ],
          ),
        ),
      ),
    );

    overlay.insert(entry);
    controller.play();

    Future.delayed(const Duration(seconds: 1), () {
      controller.dispose();
      entry.remove();
    });
  }
}