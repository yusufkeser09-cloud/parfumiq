import 'dart:convert';
import '../models/perfume_model.dart';
import '../models/scent_profile_model.dart';
import '../repositories/perfume_repository.dart';

abstract class AiRecommendationService {
  Future<Map<String, dynamic>> getAiRecommendation(Map<String, dynamic> userProfile);
}

/// The system prompt template for real AI integration.
const String davudScentIqPrompt = """
You are Davud ScentIQ, an AI-supported fragrance stylist.
Give direct, premium, practical perfume recommendations.
Avoid exaggerated claims. Do not say a perfume will definitely attract people or is guaranteed to be liked.
Do not use "exact copy" or "identical clone" for dupes/alternatives. Use "similar scent profile".
Always provide a clear "Net Hüküm" (Net Verdict) which evaluates price, risk, and wearability.
Tone: Premium, clean, modern, direct, decision-oriented. Turkish language only.
Translate notes into human decisions: e.g. instead of just listing top notes, say where it fits, how it feels, and if it's safe.
""";

class MockAiService implements AiRecommendationService {
  final PerfumeRepository _repository;

  MockAiService(this._repository);

  @override
  Future<Map<String, dynamic>> getAiRecommendation(Map<String, dynamic> userProfile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final age = userProfile['age'] as String? ?? '25+';
    final gender = userProfile['gender'] as String? ?? 'unisex';
    final budget = userProfile['budget'] as String? ?? '₺₺';
    final useCase = userProfile['useCase'] as String? ?? 'Günlük';
    final intensity = userProfile['intensity'] as String? ?? 'balanced';
    final designerOrNiche = userProfile['designerOrNiche'] as String? ?? 'designer';
    final moods = List<String>.from(userProfile['moods'] ?? ['fresh']);
    final dislikedMoods = List<String>.from(userProfile['dislikedMoods'] ?? []);

    // 1. Calculate profile
    final profile = _repository.calculateScentProfile(
      age: age,
      gender: gender,
      budget: budget,
      useCase: useCase,
      moods: moods,
      dislikedMoods: dislikedMoods,
      intensity: intensity,
      designerOrNiche: designerOrNiche,
    );

    // 2. Fetch recommendations
    final recommendations = _repository.getProfileRecommendations(
      profile: profile,
      gender: gender,
      budget: budget,
      designerOrNiche: designerOrNiche,
    );

    return {
      'profile': profile.toJson(),
      'recommendations': recommendations.map((p) => p.toJson()).toList(),
    };
  }
}

class GeminiAiService implements AiRecommendationService {
  // Placeholder for real Gemini API integration
  // Under the hood, this will use packages like google_generative_ai
  final String apiKey;
  
  GeminiAiService({required this.apiKey});

  @override
  Future<Map<String, dynamic>> getAiRecommendation(Map<String, dynamic> userProfile) async {
    // In a real app, you would make an API call to Gemini using the prompt:
    // systemInstruction: davudScentIqPrompt
    // prompt: jsonEncode(userProfile)
    // Response would be parsed as JSON matching the structure in MockAiService.
    throw UnimplementedError('Gemini API call requires api key config and network permission.');
  }
}

class OpenAiService implements AiRecommendationService {
  // Placeholder for OpenAI API integration
  final String apiKey;

  OpenAiService({required this.apiKey});

  @override
  Future<Map<String, dynamic>> getAiRecommendation(Map<String, dynamic> userProfile) async {
    // In a real app, you would make an API call to OpenAI chat completion endpoint
    // with messages: system (davudScentIqPrompt) and user (jsonEncode(userProfile))
    throw UnimplementedError('OpenAI API call requires api key config and network permission.');
  }
}
