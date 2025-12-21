class Session {
  final int id;
  final int profileId;
  final String profileName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalDuration;
  final int quantity;
  final String comments;
  final List<Map<String, dynamic>> timestamps;
  final List<Map<String, dynamic>> stepDurations;

  Session({
    required this.id,
    required this.profileId,
    required this.profileName,
    required this.startTime,
    required this.endTime,
    required this.totalDuration,
    required this.quantity,
    required this.comments,
    required this.timestamps,
    required this.stepDurations,
  });
}
