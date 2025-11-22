import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DurationInputSheet extends StatefulWidget {
  final Duration initialDuration;
  final ValueChanged<Duration> onDurationSelected;

  const DurationInputSheet({
    super.key,
    required this.initialDuration,
    required this.onDurationSelected,
  });

  @override
  State<DurationInputSheet> createState() => _DurationInputSheetState();
}

class _DurationInputSheetState extends State<DurationInputSheet> {
  late TextEditingController _controller;
  String _digits = '';
  Duration _previewDuration = Duration.zero;
  bool _hasError = false;
  String? _errorMessage;
  bool _isSecondsMode = true; // true = secondes, false = hhmmss

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Start with empty input
    _previewDuration = widget.initialDuration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      if (_digits.isEmpty) {
        _previewDuration = Duration.zero;
        _hasError = false;
        _errorMessage = null;
        return;
      }

      if (_isSecondsMode) {
        // Parse as total seconds
        final totalSeconds = int.tryParse(_digits);
        if (totalSeconds == null) {
          _hasError = true;
          _errorMessage = 'Saisie invalide';
          return;
        }

        // Check max limit (24 hours = 86400 seconds)
        if (totalSeconds > 86400) {
          _hasError = true;
          _errorMessage = 'Maximum 24 heures (86400 secondes)';
          _previewDuration = Duration(seconds: 86400);
          return;
        }

        _hasError = false;
        _errorMessage = null;
        _previewDuration = Duration(seconds: totalSeconds);
      } else {
        // Parse as hhmmss format
        final parsed = _parseHHMMSS(_digits);
        if (parsed == null) {
          _hasError = true;
          _errorMessage = 'Format invalide (ex: 12530 = 1h25m30s)';
          return;
        }

        _hasError = false;
        _errorMessage = null;
        _previewDuration = parsed;
      }
    });
  }

  Duration? _parseHHMMSS(String input) {
    // Pad with leading zeros to ensure 6 digits
    final padded = input.padLeft(6, '0');
    if (padded.length > 6) return null;

    final hours = int.tryParse(padded.substring(0, 2));
    final minutes = int.tryParse(padded.substring(2, 4));
    final seconds = int.tryParse(padded.substring(4, 6));

    if (hours == null || minutes == null || seconds == null) return null;
    if (minutes > 59 || seconds > 59) return null;
    if (hours > 23) return null;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatPreview(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onValidate() {
    if (_hasError || _previewDuration.inSeconds == 0) {
      return;
    }
    widget.onDurationSelected(_previewDuration);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Durée du timer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Preview (big display)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hasError ? Colors.red.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _hasError ? Colors.red : Colors.grey.shade300, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  _formatPreview(_previewDuration),
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    color: _hasError ? Colors.red : Colors.black,
                  ),
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Mode switch
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Convert current preview to seconds
                        final currentSeconds = _previewDuration.inSeconds;
                        _isSecondsMode = true;
                        _digits = currentSeconds > 0 ? currentSeconds.toString() : '';
                        _controller.text = _digits;
                        _updatePreview();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: _isSecondsMode ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Secondes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _isSecondsMode ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Convert current preview to hhmmss format
                        final h = _previewDuration.inHours;
                        final m = _previewDuration.inMinutes.remainder(60);
                        final s = _previewDuration.inSeconds.remainder(60);
                        _isSecondsMode = false;
                        _digits = _previewDuration.inSeconds > 0
                            ? '${h.toString().padLeft(2, '0')}${m.toString().padLeft(2, '0')}${s.toString().padLeft(2, '0')}'
                            : '';
                        _controller.text = _digits;
                        _updatePreview();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: !_isSecondsMode ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'hhmmss',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: !_isSecondsMode ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Input field
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            autofocus: true,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              // ...existing code...
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: _digits.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _digits = '';
                        _updatePreview();
                      },
                    )
                  : null,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (value) {
              _digits = value;
              _updatePreview();
            },
          ),
          const SizedBox(height: 6),
          Text(
            _isSecondsMode ? 'Ex: 90 = 1min30s, 3600 = 1h' : 'Ex: 12530 = 1h25m30s, 30 = 30s',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _hasError || _previewDuration.inSeconds == 0 ? null : _onValidate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Valider',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
