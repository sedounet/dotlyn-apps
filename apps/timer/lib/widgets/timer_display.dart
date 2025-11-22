import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_state.dart';
import '../providers/timer_provider.dart';
import 'duration_input_sheet.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  void _showDurationInput(BuildContext context, TimerProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DurationInputSheet(
        initialDuration: provider.duration,
        onDurationSelected: (duration) {
          provider.validateAndCorrectInput(
            '${duration.inHours}:${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}',
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final remaining = timerProvider.remaining;
    final status = timerProvider.status;

    // Display remaining time when running/paused, duration when idle
    final displayDuration = status == TimerStatus.idle ? timerProvider.duration : remaining;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: (status == TimerStatus.idle || status == TimerStatus.paused)
                ? () => _showDurationInput(context, timerProvider)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: (status == TimerStatus.idle || status == TimerStatus.paused)
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    )
                  : null,
              child: Text(
                displayDuration.inSeconds == 0 ? '00:00:00' : _formatDuration(displayDuration),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w900,
                  fontSize: 48,
                  color: displayDuration.inSeconds == 0 ? Colors.grey.shade300 : Colors.black,
                ),
              ),
            ),
          ),
          if (status == TimerStatus.idle || status == TimerStatus.paused)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Tap pour modifier',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          if (timerProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                timerProvider.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
