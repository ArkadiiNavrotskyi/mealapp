import 'dart:async';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../utils/responsive.dart';

class CookingModeScreen extends StatefulWidget {
  final Meal meal;

  const CookingModeScreen({super.key, required this.meal});

  @override
  State<CookingModeScreen> createState() => _CookingModeScreenState();
}

class _CookingModeScreenState extends State<CookingModeScreen> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.meal.steps;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Cooking: ${widget.meal.title}'),
        ),
      ),
      body: Column(
        children: [
          // Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_current + 1} of ${steps.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE85D04),
                      ),
                    ),
                    Text(
                      '${((_current + 1) / steps.length * 100).round()}%',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_current + 1) / steps.length,
                    minHeight: 6,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFE85D04)),
                  ),
                ),
              ],
            ),
          ),

          // Steps (swipeable)
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: steps.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE85D04)
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                color: Color(0xFFE85D04),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            steps[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                              Responsive.fontSize(context, baseSize: 22),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (i == steps.length - 1)
                            const _FinishBadge(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Step timer
          StepTimer(),
          const SizedBox(height: 12),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _current == 0
                        ? null
                        : () => _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE85D04),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (_current == steps.length - 1) {
                        Navigator.pop(context);
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    icon: Icon(_current == steps.length - 1
                        ? Icons.check
                        : Icons.arrow_forward),
                    label: Text(
                        _current == steps.length - 1 ? 'Done' : 'Next'),
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

class _FinishBadge extends StatelessWidget {
  const _FinishBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF43A047).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, color: Color(0xFF43A047)),
          SizedBox(width: 8),
          Text(
            'Enjoy your meal!',
            style: TextStyle(
              color: Color(0xFF43A047),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple 1-minute step timer (independent of meal duration).
class StepTimer extends StatefulWidget {
  @override
  State<StepTimer> createState() => _StepTimerState();
}

class _StepTimerState extends State<StepTimer> {
  int _seconds = 0;
  Timer? _timer;
  bool _running = false;

  void _toggle() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _seconds++);
      });
      setState(() => _running = true);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _seconds = 0;
      _running = false;
    });
  }

  String get _formatted {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Color(0xFFE85D04)),
          const SizedBox(width: 12),
          Text(
            _formatted,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(_running ? Icons.pause : Icons.play_arrow),
            color: Colors.white,
            onPressed: _toggle,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            color: Colors.white70,
            onPressed: _reset,
          ),
        ],
      ),
    );
  }
}