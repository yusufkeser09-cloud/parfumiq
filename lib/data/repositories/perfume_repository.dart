import '../database/perfume_seed.dart';
import '../database/boyner_perfumes.dart';
import '../database/sephora_perfumes.dart';
import '../models/perfume_model.dart';
import '../models/scent_profile_model.dart';

class PerfumeRepository {
  final List<PerfumeModel> _perfumes = [...seedPerfumes, ...boynerPerfumes, ...sephoraPerfumes];

  List<PerfumeModel> getAll() {
    return _perfumes;
  }

  PerfumeModel? getById(String id) {
    try {
      return _perfumes.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<PerfumeModel> search(String query) {
    if (query.isEmpty) return [];
    final lowercaseQuery = query.toLowerCase();
    return _perfumes.where((p) {
      final matchName = p.name.toLowerCase().contains(lowercaseQuery);
      final matchBrand = p.brand.toLowerCase().contains(lowercaseQuery);
      final matchNotes = p.topNotes.any((n) => n.toLowerCase().contains(lowercaseQuery)) ||
                         p.middleNotes.any((n) => n.toLowerCase().contains(lowercaseQuery)) ||
                         p.baseNotes.any((n) => n.toLowerCase().contains(lowercaseQuery));
      final matchFamily = p.fragranceFamily.toLowerCase().contains(lowercaseQuery);
      final matchTags = p.tags.any((t) => t.toLowerCase().contains(lowercaseQuery));
      return matchName || matchBrand || matchNotes || matchFamily || matchTags;
    }).toList();
  }

  // Scent Profile Matcher
  ScentProfileModel calculateScentProfile({
    required String age,
    required String gender,
    required String budget,
    required String useCase,
    required List<String> moods,
    required List<String> dislikedMoods,
    required String intensity,
    required String designerOrNiche,
  }) {
    // Determine the profile name based on responses
    String profileName = 'Minimal Fresh Style';
    String explanation = 'Temiz, sade ve günlük kullanıma uygun, yormayan kokulardan hoşlanıyorsun. Genellikle hafif narenciyeli ve sabunsu havalar tarzındır.';
    List<String> bestOccasions = ['Ofis', 'Spor Sonrası', 'Sıcak Yaz Günleri', 'Günlük Rutin'];
    String scentPersonality = 'Temiz, profesyonel, güven verici ve canlandırıcı.';
    String recommendedDirection = 'Narenciyeli, taze yeşil ve hafif odunsu sucul kokular.';

    if (moods.contains('sweet') || moods.contains('vanilla')) {
      if (gender == 'male' && age == '25+') {
        profileName = 'Dark Vanilla Gentleman';
        explanation = 'Maskülen, hafif tatlı, zengin tütün ve vanilya notalarının ön planda olduğu, karakterli ve olgun kokulardan hoşlanıyorsun.';
        bestOccasions = ['Date', 'Özel Gece Davetleri', 'Kış Aylarında Günlük'];
        scentPersonality = 'Çekici, karizmatik, gizemli ve kendinden emin.';
        recommendedDirection = 'Vanilya, tütün, kakule ve zengin oryantal odunsular.';
      } else if (moods.contains('oud') || moods.contains('woody')) {
        profileName = 'Mysterious Oud Type';
        explanation = 'Karanlık, yoğun, reçinemsi ve odunsu/oryantal notaları seviyorsun. Karakterli ve arkanda imza bırakan kokular tam senlik.';
        bestOccasions = ['Soğuk Kış Geceleri', 'Resmi Akşam Yemekleri', 'Niş Kokteyller'];
        scentPersonality = 'Gizemli, lüks, baskın ve unutulmaz.';
        recommendedDirection = 'Ud (Oud), tütsü, deri ve yoğun baharatlı odunsular.';
      } else {
        profileName = 'Sweet Gourmand Soul';
        explanation = 'Çikolatamsı, karamelli, tarçınlı ve lezzetli tatlılık barındıran gurme kokular senin tarzın. Genç, dinamik ve enerjik hissettirir.';
        bestOccasions = ['Gece Kulüpleri', 'Kışlık Günlük Giyim', 'Arkadaş Buluşmaları'];
        scentPersonality = 'Sıcak, oyuncu, dışa dönük ve davetkar.';
        recommendedDirection = 'Tarçın, vanilya, pralin ve yoğun tonka fasulyesi içeren kokular.';
      }
    } else if (moods.contains('woody') || moods.contains('amber')) {
      if (designerOrNiche == 'niche' || budget == '₺₺₺' || budget == '₺₺₺₺') {
        profileName = 'Clean Luxury';
        explanation = 'Hem lüks ve niş hissiyatlı olan hem de aşırı ağır olmayan, sedir ve sandal ağacı gibi temiz odunsu zengin kokuları tercih ediyorsun.';
        bestOccasions = ['Özel Toplantılar', 'Şık Akşam Yemekleri', 'İmza Günlük Koku'];
        scentPersonality = 'Elit, sade, dingin ve kendine yeten.';
        recommendedDirection = 'İris, hafif tütsü, sedir, sandal ağacı ve miskli niş kokular.';
      } else {
        profileName = 'Modern Office Scent';
        explanation = 'İş ortamına uygun, kimseyi boğmayan ama son derece prestijli kokan temiz sabunsu veya hafif taze baharatlı imza kokuları seviyorsun.';
        bestOccasions = ['Ofis/Toplantı', 'İş Görüşmeleri', 'Baharda Günlük'];
        scentPersonality = 'Profesyonel, dengeli, güven verici ve temiz.';
        recommendedDirection = 'Bergamot, lavanta, sedir ve hafif ambroxan/mavi kokular.';
      }
    } else if (moods.contains('floral') || moods.contains('powdery')) {
      profileName = 'Soft Elegant Rose';
      explanation = 'Pudralı, temiz çiçeksi, lavanta veya hafif iris temalı son derece centilmen ve şık kokuları beğeniyorsun.';
      bestOccasions = ['Şık Date\'ler', 'Sanat Galerisi/Kokteyl', 'Bahar Günleri'];
      scentPersonality = 'Sanatsal, kibar, entelektüel ve sofistike.';
      recommendedDirection = 'Pudralı iris, lavanta, armut ve temiz miskli çiçeksi kokular.';
    } else if (moods.contains('fresh') || moods.contains('citrus')) {
      profileName = 'Fresh Rich Energy';
      explanation = 'Deniz esintileri, bol narenciye ve taze nane barındıran, adeta zengin bir İtalyan yaz tatilindeymişsin gibi hissettiren lüks ferah kokular.';
      bestOccasions = ['Yaz Tatili', 'Sıcak Günlerde Günlük', 'Spor Sonrası'];
      scentPersonality = 'Dinamik, lüks sever, atletik ve cana yakın.';
      recommendedDirection = 'Deniz notaları, mandalina, greyfurt, nane ve hafif yeşil servi ağacı.';
    }

    return ScentProfileModel(
      profileName: profileName,
      shortExplanation: explanation,
      bestOccasions: bestOccasions,
      scentPersonality: scentPersonality,
      recommendedDirection: recommendedDirection,
    );
  }

  // Get Scent Profile Recommendations (5 slots)
  List<PerfumeModel> getProfileRecommendations({
    required ScentProfileModel profile,
    required String gender,
    required String budget,
    required String designerOrNiche,
  }) {
    List<PerfumeModel> pool = List.from(_perfumes);

    // Apply gender filter
    if (gender != 'preferNotToSay') {
      pool = pool.where((p) => p.genderPerception == 'unisex' || p.genderPerception == gender).toList();
    }

    // Sort/Filter logic for 5 recommendations:
    // 1. Best main perfume
    // 2. Cheaper alternative
    // 3. Premium alternative
    // 4. More unique alternative
    // 5. Layering suggestion

    PerfumeModel? bestMain;
    PerfumeModel? cheaper;
    PerfumeModel? premium;
    PerfumeModel? unique;
    PerfumeModel? layering;

    // Filter by family/mood match first
    if (profile.profileName == 'Clean Luxury' || profile.profileName == 'Modern Office Scent') {
      bestMain = _findInPool(pool, ['creed_aventus', 'montblanc_explorer', 'bleu_de_chanel']);
      cheaper = _findInPool(pool, ['montblanc_explorer', 'zara_vibrant_leather', 'club_de_nuit_intense']);
      premium = _findInPool(pool, ['creed_aventus', 'dior_homme_intense']);
      unique = _findInPool(pool, ['dior_homme_intense', 'by_the_fireplace']);
      layering = _findInPool(pool, ['zara_vibrant_leather']); // light clean
    } else if (profile.profileName == 'Dark Vanilla Gentleman' || profile.profileName == 'Sweet Gourmand Soul') {
      bestMain = _findInPool(pool, ['le_male_le_parfum', 'most_wanted_parfum', 'tobacco_vanille']);
      cheaper = _findInPool(pool, ['lattafa_khamrah', 'club_de_nuit_intense']);
      premium = _findInPool(pool, ['angels_share', 'tobacco_vanille', 'pdm_layton']);
      unique = _findInPool(pool, ['by_the_fireplace', 'lost_cherry']);
      layering = _findInPool(pool, ['lattafa_khamrah']);
    } else if (profile.profileName == 'Fresh Rich Energy' || profile.profileName == 'Minimal Fresh Style') {
      bestMain = _findInPool(pool, ['chanel_allure_extreme', 'acqua_di_gio_profondo', 'bleu_de_chanel']);
      cheaper = _findInPool(pool, ['zara_vibrant_leather', 'montblanc_explorer']);
      premium = _findInPool(pool, ['creed_aventus']);
      unique = _findInPool(pool, ['montblanc_explorer']);
      layering = _findInPool(pool, ['zara_vibrant_leather']);
    } else if (profile.profileName == 'Soft Elegant Rose' || profile.profileName == 'Mysterious Oud Type') {
      bestMain = _findInPool(pool, ['dior_homme_intense', 'la_nuit_de_lhomme', 'tobacco_vanille']);
      cheaper = _findInPool(pool, ['lattafa_khamrah']);
      premium = _findInPool(pool, ['angels_share', 'lost_cherry', 'pdm_layton']);
      unique = _findInPool(pool, ['by_the_fireplace', 'dior_sauvage_elixir']);
      layering = _findInPool(pool, ['la_nuit_de_lhomme']);
    }

    // Fallbacks if lists are empty
    bestMain ??= pool.isNotEmpty ? pool[0] : _perfumes[3]; // Bleu de Chanel
    cheaper ??= pool.firstWhere((p) => p.category == 'affordable', orElse: () => _perfumes[1]); // Club de Nuit
    premium ??= pool.firstWhere((p) => p.category == 'niche', orElse: () => _perfumes[0]); // Aventus
    unique ??= pool.firstWhere((p) => p.riskLevel == 'Riskli ama Karakterli', orElse: () => _perfumes[18]); // By the fireplace
    layering ??= pool.firstWhere((p) => p.freshnessLevel >= 4, orElse: () => _perfumes[10]); // Zara Vibrant

    return [bestMain, cheaper, premium, unique, layering];
  }

  PerfumeModel? _findInPool(List<PerfumeModel> pool, List<String> preferredIds) {
    for (final id in preferredIds) {
      final match = pool.where((p) => p.id == id);
      if (match.isNotEmpty) return match.first;
    }
    return null;
  }

  // Get Alternative Finder results
  List<PerfumeModel> getAlternativeFinderResults(String perfumeId) {
    final perfume = getById(perfumeId);
    if (perfume == null) return [];

    List<PerfumeModel> results = [];
    
    // 1. Cheaper alternatives
    for (final id in perfume.cheaperAlternatives) {
      final p = getById(id);
      if (p != null) results.add(p);
    }
    // 2. Premium alternatives
    for (final id in perfume.premiumAlternatives) {
      final p = getById(id);
      if (p != null) results.add(p);
    }
    // 3. Similar perfumes
    for (final id in perfume.similarPerfumes) {
      if (!results.any((r) => r.id == id)) {
        final p = getById(id);
        if (p != null) results.add(p);
      }
    }

    // Add general fallback if we don't have enough results
    if (results.isEmpty) {
      if (perfume.category == 'niche') {
        results.addAll(_perfumes.where((p) => p.category == 'affordable' && p.fragranceFamily == perfume.fragranceFamily).take(2));
      } else {
        results.addAll(_perfumes.where((p) => p.category == 'niche' && p.fragranceFamily == perfume.fragranceFamily).take(2));
      }
    }

    // Return capped list
    return results;
  }

  // Gift Mode Finder
  List<PerfumeModel> getGiftRecommendations({
    required String gender,
    required String style,
    required String budget,
    required String safeOrImpressive,
  }) {
    List<PerfumeModel> pool = List.from(_perfumes);

    // Filter gender
    if (gender != 'unisex') {
      pool = pool.where((p) => p.genderPerception == 'unisex' || p.genderPerception == gender).toList();
    }

    // Filter budget
    if (budget == '₺') {
      pool = pool.where((p) => p.priceBand == '₺' || p.priceBand == '₺₺').toList();
    } else if (budget == '₺₺₺') {
      pool = pool.where((p) => p.priceBand == '₺₺₺' || p.priceBand == '₺₺₺₺').toList();
    }

    // Sort by suitability
    if (safeOrImpressive == 'safe') {
      pool.sort((a, b) => b.giftSuitability.compareTo(a.giftSuitability));
    } else {
      // Impressive means riskLevel might be higher, and high character
      pool.sort((a, b) {
        final aVal = a.riskLevel == 'Riskli ama Karakterli' ? 5.0 : a.giftSuitability;
        final bVal = b.riskLevel == 'Riskli ama Karakterli' ? 5.0 : b.giftSuitability;
        return bVal.compareTo(aVal);
      });
    }

    return pool.take(5).toList();
  }

  // Daily Scent Suggestion Engine
  PerfumeModel getDailySuggestion({
    required int temperature, // Celsius
    required String season,
    required String plan, // 'office' | 'date' | 'casual' | 'special'
    required String mood, // 'fresh' | 'sweet' | 'bold' | 'elegant'
  }) {
    List<PerfumeModel> pool = List.from(_perfumes);

    // Weather rules: If temp > 25°C, filter out heavy perfumes (sweetnessLevel >= 4, spicyLevel >= 4, unless it has high freshness)
    if (temperature > 25) {
      pool = pool.where((p) => p.sweetnessLevel <= 3 || p.freshnessLevel >= 3).toList();
    }

    // Season rules
    pool = pool.where((p) => p.season.contains(season) || p.season.length >= 3).toList();

    // Sort by use cases suitability
    pool.sort((a, b) {
      double aScore = 0;
      double bScore = 0;

      if (plan == 'office') {
        aScore = a.officeSuitability;
        bScore = b.officeSuitability;
      } else if (plan == 'date') {
        aScore = a.dateSuitability;
        bScore = b.dateSuitability;
      } else if (plan == 'special') {
        aScore = a.giftSuitability; // general premium factor
        bScore = b.giftSuitability;
      } else {
        aScore = (a.officeSuitability + a.dateSuitability) / 2;
        bScore = (b.officeSuitability + b.dateSuitability) / 2;
      }

      // Mood booster
      if (mood == 'fresh') {
        aScore += a.freshnessLevel;
        bScore += b.freshnessLevel;
      } else if (mood == 'sweet') {
        aScore += a.sweetnessLevel;
        bScore += b.sweetnessLevel;
      } else if (mood == 'bold') {
        aScore += (a.spicyLevel + a.woodyLevel) / 2;
        bScore += (b.spicyLevel + b.woodyLevel) / 2;
      }

      return bScore.compareTo(aScore);
    });

    return pool.isNotEmpty ? pool.first : _perfumes[3]; // Bleu de Chanel fallback
  }

  // Wardrobe Analyzer
  String analyzeWardrobe(List<PerfumeModel> userPerfumes) {
    if (userPerfumes.isEmpty) {
      return 'Gardırobun tamamen boş! İlk iş olarak bir koku testi yapmalı ve çok yönlü bir imza parfümü edinmelisin.';
    }

    int summerCount = 0;
    int winterCount = 0;
    int officeCount = 0;
    int dateCount = 0;
    int sweetCount = 0;
    int freshCount = 0;

    for (final p in userPerfumes) {
      if (p.season.contains('Yaz')) summerCount++;
      if (p.season.contains('Kış')) winterCount++;
      if (p.useCases.contains('Ofis') || p.officeSuitability >= 4.0) officeCount++;
      if (p.useCases.contains('Date') || p.dateSuitability >= 4.0) dateCount++;
      if (p.sweetnessLevel >= 4) sweetCount++;
      if (p.freshnessLevel >= 4) freshCount++;
    }

    List<String> advices = [];

    if (summerCount == 0 && userPerfumes.isNotEmpty) {
      advices.add('Koleksiyonunda sıcak havalar için ferah bir yaz kokusu (Yazlık) eksik. Tazeleyici bir deniz/sucul koku eklemelisin.');
    }
    if (winterCount == 0 && userPerfumes.isNotEmpty) {
      advices.add('Soğuk kış günlerinde seni sıcak hissettirecek tatlı/baharatlı veya yoğun odunsu bir kış kokusu edinmelisin.');
    }
    if (officeCount == 0) {
      advices.add('İş ortamına ve ofise uygun, temiz ve kimseyi rahatsız etmeyecek sabunsu veya hafif narenciyeli bir koku eklemelisin.');
    }
    if (dateCount == 0) {
      advices.add('Romantik buluşmalar (date) için daha davetkar, lavantalı veya hafif tatlı baharatlı bir koku eklemen iyi olur.');
    }
    if (sweetCount > userPerfumes.length / 2 && userPerfumes.length >= 3) {
      advices.add('Çok fazla benzer şekerli/gurme kokun var. Koleksiyonuna denge getirmek için kuru odunsu veya ferah narenciye kokuları yönelmelisin.');
    }
    if (freshCount > userPerfumes.length / 2 && userPerfumes.length >= 3) {
      advices.add('Gardırobun ferah ve mavi kokularla dolup taşmış. Kış ve gece kullanımı için daha sıcak baharatlı veya vanilyalı bir koku edinme vaktin gelmiş.');
    }

    if (advices.isEmpty) {
      return 'Harika denge! Gardırobunda yazlık, kışlık, ofis ve date ihtiyaçlarını karşılayan dengeli ve elit bir koku yelpazesi bulunuyor.';
    }

    return advices.join('\n\n');
  }
}
