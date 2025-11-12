import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/timer_state.dart';
import '../providers/timer_provider.dart';
import '../services/timer_service.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay> {
  late TextEditingController _controller;
  final TimerService _timerService = TimerService();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final remaining = timerProvider.remaining;
    final status = timerProvider.status;

    // Mettre à jour le texte du controller
    _controller.text = _timerService.formatDuration(remaining);
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Satoshi',
              fontWeight: FontWeight.w900,
              fontSize: 56,
            ),
            decoration: const InputDecoration(border: InputBorder.none, hintText: '00:05:00'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
              LengthLimitingTextInputFormatter(8),
            ],
            readOnly: status != TimerStatus.idle,
            enabled: status == TimerStatus.idle,
            onSubmitted: (value) {
              final corrected = timerProvider.validateAndCorrectInput(value);
              if (corrected != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Temps corrigé : $corrected'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
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
