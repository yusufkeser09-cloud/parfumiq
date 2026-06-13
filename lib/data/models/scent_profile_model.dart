class ScentProfileModel {
  final String profileName;
  final String shortExplanation;
  final List<String> bestOccasions;
  final String scentPersonality;
  final String recommendedDirection;

  ScentProfileModel({
    required this.profileName,
    required this.shortExplanation,
    required this.bestOccasions,
    required this.scentPersonality,
    required this.recommendedDirection,
  });

  factory ScentProfileModel.fromJson(Map<String, dynamic> json) {
    return ScentProfileModel(
      profileName: json['profileName'] as String,
      shortExplanation: json['shortExplanation'] as String,
      bestOccasions: List<String>.from(json['bestOccasions'] ?? []),
      scentPersonality: json['scentPersonality'] as String,
      recommendedDirection: json['recommendedDirection'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileName': profileName,
      'shortExplanation': shortExplanation,
      'bestOccasions': bestOccasions,
      'scentPersonality': scentPersonality,
      'recommendedDirection': recommendedDirection,
    };
  }
}
