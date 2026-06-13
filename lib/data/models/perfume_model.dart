class PerfumeModel {
  final String id;
  final String name;
  final String brand;
  final String genderPerception; // 'male' | 'female' | 'unisex' | 'preferNotToSay'
  final String fragranceFamily;
  final List<String> topNotes;
  final List<String> middleNotes;
  final List<String> baseNotes;
  final int sweetnessLevel; // 1-5
  final int freshnessLevel; // 1-5
  final int woodyLevel;     // 1-5
  final int spicyLevel;     // 1-5
  final List<String> tags;
  final String longevity;   // 'Zayıf' | 'Orta' | 'Kalıcı' | 'Çok Kalıcı'
  final String projection;  // 'Zayıf' | 'Orta' | 'Güçlü' | 'Canavar'
  final List<String> season; // 'Yaz', 'Sonbahar', 'Kış', 'İlkbahar'
  final List<String> useCases; // 'Ofis', 'Günlük', 'Date', 'Gece/Kulüp', 'Spor'
  final String ageProfile;  // 'Genç' | '25+' | '35+' | 'Her Yaşa Uygun'
  final String priceBand;   // '₺' | '₺₺' | '₺₺₺' | '₺₺₺₺'
  final String category;    // 'designer' | 'niche' | 'affordable' | 'alternative'
  final List<String> similarPerfumes; // List of perfume IDs
  final List<String> cheaperAlternatives; // List of perfume IDs
  final List<String> premiumAlternatives; // List of perfume IDs
  final double giftSuitability;    // 0.0 - 5.0
  final double officeSuitability;  // 0.0 - 5.0
  final double dateSuitability;    // 0.0 - 5.0
  final double summerSuitability;  // 0.0 - 5.0
  final double winterSuitability;  // 0.0 - 5.0
  final String riskLevel;          // 'Güvenli Seçim' | 'Dengeli' | 'Riskli ama Karakterli'
  final String davudComment;
  final String netVerdict;         // 'Net Hüküm'
  final Map<String, String> affiliateLinks; // Key: Store name, Value: URL
  final String imageUrl;

  PerfumeModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.genderPerception,
    required this.fragranceFamily,
    required this.topNotes,
    required this.middleNotes,
    required this.baseNotes,
    required this.sweetnessLevel,
    required this.freshnessLevel,
    required this.woodyLevel,
    required this.spicyLevel,
    required this.tags,
    required this.longevity,
    required this.projection,
    required this.season,
    required this.useCases,
    required this.ageProfile,
    required this.priceBand,
    required this.category,
    required this.similarPerfumes,
    required this.cheaperAlternatives,
    required this.premiumAlternatives,
    required this.giftSuitability,
    required this.officeSuitability,
    required this.dateSuitability,
    required this.summerSuitability,
    required this.winterSuitability,
    required this.riskLevel,
    required this.davudComment,
    required this.netVerdict,
    required this.affiliateLinks,
    required this.imageUrl,
  });

  factory PerfumeModel.fromJson(Map<String, dynamic> json) {
    return PerfumeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      genderPerception: json['genderPerception'] as String,
      fragranceFamily: json['fragranceFamily'] as String,
      topNotes: List<String>.from(json['topNotes'] ?? []),
      middleNotes: List<String>.from(json['middleNotes'] ?? []),
      baseNotes: List<String>.from(json['baseNotes'] ?? []),
      sweetnessLevel: json['sweetnessLevel'] as int,
      freshnessLevel: json['freshnessLevel'] as int,
      woodyLevel: json['woodyLevel'] as int,
      spicyLevel: json['spicyLevel'] as int,
      tags: List<String>.from(json['tags'] ?? []),
      longevity: json['longevity'] as String,
      projection: json['projection'] as String,
      season: List<String>.from(json['season'] ?? []),
      useCases: List<String>.from(json['useCases'] ?? []),
      ageProfile: json['ageProfile'] as String,
      priceBand: json['priceBand'] as String,
      category: json['category'] as String,
      similarPerfumes: List<String>.from(json['similarPerfumes'] ?? []),
      cheaperAlternatives: List<String>.from(json['cheaperAlternatives'] ?? []),
      premiumAlternatives: List<String>.from(json['premiumAlternatives'] ?? []),
      giftSuitability: (json['giftSuitability'] as num).toDouble(),
      officeSuitability: (json['officeSuitability'] as num).toDouble(),
      dateSuitability: (json['dateSuitability'] as num).toDouble(),
      summerSuitability: (json['summerSuitability'] as num).toDouble(),
      winterSuitability: (json['winterSuitability'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      davudComment: json['davudComment'] as String,
      netVerdict: json['netVerdict'] as String,
      affiliateLinks: Map<String, String>.from(json['affiliateLinks'] ?? {}),
      imageUrl: json['imageUrl'] as String? ?? 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=500',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'genderPerception': genderPerception,
      'fragranceFamily': fragranceFamily,
      'topNotes': topNotes,
      'middleNotes': middleNotes,
      'baseNotes': baseNotes,
      'sweetnessLevel': sweetnessLevel,
      'freshnessLevel': freshnessLevel,
      'woodyLevel': woodyLevel,
      'spicyLevel': spicyLevel,
      'tags': tags,
      'longevity': longevity,
      'projection': projection,
      'season': season,
      'useCases': useCases,
      'ageProfile': ageProfile,
      'priceBand': priceBand,
      'category': category,
      'similarPerfumes': similarPerfumes,
      'cheaperAlternatives': cheaperAlternatives,
      'premiumAlternatives': premiumAlternatives,
      'giftSuitability': giftSuitability,
      'officeSuitability': officeSuitability,
      'dateSuitability': dateSuitability,
      'summerSuitability': summerSuitability,
      'winterSuitability': winterSuitability,
      'riskLevel': riskLevel,
      'davudComment': davudComment,
      'netVerdict': netVerdict,
      'affiliateLinks': affiliateLinks,
      'imageUrl': imageUrl,
    };
  }
}
