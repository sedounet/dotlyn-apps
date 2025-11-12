class TimerService {
  /// Parse une chaîne hh:mm:ss vers Duration
  Duration parseDuration(String input) {
    final parts = input.split(':');
    if (parts.length != 3) {
      throw FormatException('Format invalide. Utilisez hh:mm:ss');
    }

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  /// Formate une Duration vers hh:mm:ss
  String formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Corrige une durée invalide (ex: 65 min → 1h 5min)
  Duration correctInvalidDuration(Duration duration, {Duration? maxDuration}) {
    int totalSeconds = duration.inSeconds;

    // Vérifier la limite max (12h par défaut)
    final max = maxDuration ?? Duration(hours: 12);
    if (totalSeconds > max.inSeconds) {
      return max;
    }

    // La durée est déjà correcte grâce au constructeur Duration
    return duration;
  }

  /// Vérifie si la chaîne est un format valide
  bool isValidDuration(String input) {
    try {
      parseDuration(input);
      return true;
    } catch (_) {
      return false;
    }
  }
}
