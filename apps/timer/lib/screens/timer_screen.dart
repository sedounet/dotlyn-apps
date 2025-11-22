import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    // Listen to provider changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TimerProvider>();
      provider.addListener(_onProviderChange);
    });
  }

  @override
  void dispose() {
    final provider = context.read<TimerProvider>();
    provider.removeListener(_onProviderChange);
    super.dispose();
  }

  void _onProviderChange() {
    final provider = context.read<TimerProvider>();
    // Only show dialog if flag is true and dialog not already shown
    if (provider.showCompletionDialog && !_dialogShown) {
      _dialogShown = true;
      _showCompletionDialog(provider);
    } else if (!provider.showCompletionDialog && _dialogShown) {
      // Reset flag when provider dismisses
      _dialogShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Spacer(), TimerDisplay(), SizedBox(height: 24), TimerControls(), Spacer()],
      ),
    );
  }

  void _showCompletionDialog(TimerProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⏰ Timer terminé !'),
          content: const Text('Votre session est terminée'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                provider.dismissCompletionDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Arrêter', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
