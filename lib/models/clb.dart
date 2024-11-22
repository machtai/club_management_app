class Club {
  String? id;
  String clbName;
  String leaderId;
  String description;

  Club({
    this.id,
    required this.clbName,
    required this.leaderId,
    required this.description,
  });

  // Factory method for creating a Club object from JSON
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['_id'],  // Assumes '_id' is used for the club ID in the database
      clbName: json['clb_name'] ?? json['name'],  // Fallback to 'name' if 'clb_name' isn't present
      leaderId: json['leader_id'] ?? '',  // Default to an empty string if 'leader_id' isn't provided
      description: json['des'] ?? '',  // Default to an empty string if 'des' isn't provided
    );
  }

  // Method for converting a Club object to JSON for sending to the API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,  // Only include 'id' if it exists (for updates)
      'clb_name': clbName,
      'leader_id': leaderId,
      'des': description,
    };
  }
}
