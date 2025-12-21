class Profile {
  final int id;
  final String name;
  final String description;
  final List<String> steps;
  final int? gameplayTypeId;
  final int? shipId;

  Profile({
    required this.id,
    required this.name,
    required this.description,
    required this.steps,
    this.gameplayTypeId,
    this.shipId,
  });
}
