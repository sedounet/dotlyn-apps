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
  late FocusNode _focusNode;
  final TimerService _timerService = TimerService();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final timerProvider = context.read<TimerProvider>();
    _controller = TextEditingController(text: _timerService.formatDuration(timerProvider.duration));
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });

      if (!_focusNode.hasFocus) {
        // When focus is lost, validate and correct input
        final timerProvider = context.read<TimerProvider>();
        final corrected = timerProvider.validateAndCorrectInput(_controller.text);
        if (corrected != null) {
          _controller.text = corrected;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Temps corrigé : $corrected'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    final remaining = timerProvider.remaining;
    final status = timerProvider.status;

    // Mettre à jour le texte du controller uniquement si l'utilisateur n'est pas en train d'éditer
    if (!_isEditing && status != TimerStatus.idle) {
      // Pendant que le timer tourne, mettre à jour l'affichage
      final text = _timerService.formatDuration(remaining);
      if (_controller.text != text) {
        _controller.text = text;
      }
    } else if (!_isEditing && status == TimerStatus.idle) {
      // Quand idle, afficher la durée configurée (pas remaining)
      final text = _timerService.formatDuration(timerProvider.duration);
      if (_controller.text != text) {
        _controller.text = text;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
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
                _controller.text = corrected;
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
