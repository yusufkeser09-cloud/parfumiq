import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/app_providers.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/scent_profile_test_screen.dart';
import '../../presentation/screens/scent_profile_result_screen.dart';
import '../../presentation/screens/recommendation_screen.dart';
import '../../presentation/screens/perfume_detail_screen.dart';
import '../../presentation/screens/dupe_finder_screen.dart';
import '../../presentation/screens/gift_mode_screen.dart';
import '../../presentation/screens/wardrobe_screen.dart';
import '../../presentation/screens/daily_suggestion_screen.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../../presentation/screens/premium_screen.dart';
import '../../presentation/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isSplash = state.matchedLocation == '/';
      final isOnboarding = state.matchedLocation == '/onboarding';
      
      // If we are on splash screen, don't redirect yet (let splash do its animation)
      if (isSplash) return null;

      // If onboarding is not completed and user is not on onboarding screen, redirect to onboarding
      if (!onboardingCompleted && !isOnboarding) {
        return '/onboarding';
      }

      // If onboarding is completed and user tries to access onboarding screen, redirect to home
      if (onboardingCompleted && isOnboarding) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/test',
        builder: (context, state) => const ScentProfileTestScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const ScentProfileResultScreen(),
      ),
      GoRoute(
        path: '/recommendations',
        builder: (context, state) => const RecommendationScreen(),
      ),
      GoRoute(
        path: '/perfume/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PerfumeDetailScreen(perfumeId: id);
        },
      ),
      GoRoute(
        path: '/dupes',
        builder: (context, state) => const DupeFinderScreen(),
      ),
      GoRoute(
        path: '/gift',
        builder: (context, state) => const GiftModeScreen(),
      ),
      GoRoute(
        path: '/wardrobe',
        builder: (context, state) => const WardrobeScreen(),
      ),
      GoRoute(
        path: '/daily-suggestion',
        builder: (context, state) => const DailySuggestionScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
