import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/perfume_model.dart';
import '../../data/models/scent_profile_model.dart';
import '../../data/repositories/perfume_repository.dart';
import '../../data/services/ai_recommendation_service.dart';

// Repositories & Services Providers
final perfumeRepositoryProvider = Provider<PerfumeRepository>((ref) {
  return PerfumeRepository();
});

final aiRecommendationServiceProvider = Provider<AiRecommendationService>((ref) {
  final repo = ref.watch(perfumeRepositoryProvider);
  return MockAiService(repo);
});

// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized yet');
});

// Onboarding State Provider
final onboardingCompletedProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});

class OnboardingNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  OnboardingNotifier(this._prefs) : super(_prefs.getBool('onboarding_completed') ?? false);

  void completeOnboarding() {
    _prefs.setBool('onboarding_completed', true);
    state = true;
  }

  void resetOnboarding() {
    _prefs.setBool('onboarding_completed', false);
    state = false;
  }
}

// Scent Profile Test Controller
final scentTestResponseProvider = StateNotifierProvider<ScentTestNotifier, Map<String, dynamic>>((ref) {
  return ScentTestNotifier();
});

class ScentTestNotifier extends StateNotifier<Map<String, dynamic>> {
  ScentTestNotifier() : super(_initialState);

  static Map<String, dynamic> get _initialState => {
        'age': '25+',
        'gender': 'unisex',
        'country': 'Turkey',
        'budget': '₺₺',
        'useCase': 'Daily',
        'moods': <String>[],
        'dislikedMoods': <String>[],
        'intensity': 'balanced',
        'longevity': 'Orta',
        'projection': 'Orta',
        'designerOrNiche': 'designer',
        'likedPerfumes': <String>[],
        'dislikedPerfumes': <String>[],
      };

  void updateField(String field, dynamic value) {
    state = {...state, field: value};
  }

  void toggleMood(String mood) {
    final list = List<String>.from(state['moods']);
    if (list.contains(mood)) {
      list.remove(mood);
    } else {
      list.add(mood);
    }
    state = {...state, 'moods': list};
  }

  void toggleDislikedMood(String mood) {
    final list = List<String>.from(state['dislikedMoods']);
    if (list.contains(mood)) {
      list.remove(mood);
    } else {
      list.add(mood);
    }
    state = {...state, 'dislikedMoods': list};
  }

  void resetTest() {
    state = _initialState;
  }
}

// Scent Test Result State
// Scent Test Result State
final scentTestResultProvider = StateNotifierProvider<ScentTestResultNotifier, Map<String, dynamic>?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ScentTestResultNotifier(prefs);
});

class ScentTestResultNotifier extends StateNotifier<Map<String, dynamic>?> {
  final SharedPreferences _prefs;

  ScentTestResultNotifier(this._prefs) : super(_loadFromPrefs(_prefs));

  static Map<String, dynamic>? _loadFromPrefs(SharedPreferences prefs) {
    final raw = prefs.getString('scent_test_result');
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void setResults(Map<String, dynamic> results) {
    _prefs.setString('scent_test_result', json.encode(results));
    state = results;
  }

  void clear() {
    _prefs.remove('scent_test_result');
    state = null;
  }
}

// Favorites Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  FavoritesNotifier(this._prefs) : super(_prefs.getStringList('favorites') ?? []);

  void toggleFavorite(String id) {
    final current = List<String>.from(state);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    _prefs.setStringList('favorites', current);
    state = current;
  }

  bool isFavorite(String id) {
    return state.contains(id);
  }

  void clear() {
    _prefs.remove('favorites');
    state = [];
  }
}

// Wardrobe Provider
final wardrobeProvider = StateNotifierProvider<WardrobeNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WardrobeNotifier(prefs);
});

class WardrobeNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  WardrobeNotifier(this._prefs) : super(_prefs.getStringList('wardrobe') ?? []);

  void addPerfume(String id) {
    if (!state.contains(id)) {
      final updated = [...state, id];
      _prefs.setStringList('wardrobe', updated);
      state = updated;
    }
  }

  void removePerfume(String id) {
    final updated = List<String>.from(state)..remove(id);
    _prefs.setStringList('wardrobe', updated);
    state = updated;
  }

  bool contains(String id) {
    return state.contains(id);
  }

  void clear() {
    _prefs.remove('wardrobe');
    state = [];
  }
}

// Accent Color Customization Provider
final accentColorIndexProvider = StateNotifierProvider<AccentColorNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AccentColorNotifier(prefs);
});

class AccentColorNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  AccentColorNotifier(this._prefs) : super(_prefs.getInt('accent_color_index') ?? 0);

  void setAccentColorIndex(int index) {
    _prefs.setInt('accent_color_index', index);
    state = index;
  }

  void reset() {
    _prefs.remove('accent_color_index');
    state = 0;
  }
}

// Theme Mode Provider (0: System, 1: Light, 2: Dark)
final themeModeIndexProvider = StateNotifierProvider<ThemeModeNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_prefs.getInt('theme_mode_index') ?? 0);

  void setThemeModeIndex(int index) {
    _prefs.setInt('theme_mode_index', index);
    state = index;
  }

  void reset() {
    _prefs.remove('theme_mode_index');
    state = 0;
  }
}

// Premium Status Provider
final isPremiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PremiumNotifier(prefs);
});

class PremiumNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  PremiumNotifier(this._prefs) : super(_prefs.getBool('is_premium_active') ?? true);

  void setPremium(bool value) {
    _prefs.setBool('is_premium_active', value);
    state = value;
  }

  void reset() {
    _prefs.setBool('is_premium_active', false);
    state = false;
  }
}
