class ProfileResource {
  final int profileId;
  final int resourceId;
  final double quantity;
  final String resourceName; // Pour affichage facile
  final String resourceUnit; // Pour affichage facile

  ProfileResource({
    required this.profileId,
    required this.resourceId,
    required this.quantity,
    required this.resourceName,
    required this.resourceUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'resource_id': resourceId,
      'quantity': quantity,
    };
  }

  factory ProfileResource.fromMap(Map<String, dynamic> map) {
    return ProfileResource(
      profileId: map['profile_id'] as int,
      resourceId: map['resource_id'] as int,
      quantity: map['quantity'] as double,
      resourceName: map['resource_name'] as String,
      resourceUnit: map['resource_unit'] as String,
    );
  }
}
