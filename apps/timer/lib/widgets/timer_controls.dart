import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_state.dart';
import '../providers/timer_provider.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final status = timerProvider.status;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Bouton Reset
        IconButton(
          icon: const Icon(Icons.restart_alt),
          iconSize: 48,
          color: status == TimerStatus.running ? Colors.grey[400] : Colors.grey[600],
          onPressed: status == TimerStatus.running ? null : timerProvider.reset,
        ),
        // Bouton Play/Pause
        IconButton(
          icon: Icon(status == TimerStatus.running ? Icons.pause : Icons.play_arrow),
          iconSize: 48,
          color: status == TimerStatus.running ? Colors.grey[700] : Colors.orange,
          onPressed: () {
            if (status == TimerStatus.running) {
              timerProvider.pause();
            } else if (status == TimerStatus.paused) {
              timerProvider.resume();
            } else {
              // Idle - start with configured duration (not the potentially-zero remaining)
              if (timerProvider.errorMessage == null) {
                timerProvider.start(timerProvider.duration);
              }
            }
          },
        ),
      ],
    );
  }
}
