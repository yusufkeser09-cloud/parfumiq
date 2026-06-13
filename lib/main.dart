import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'domain/providers/app_providers.dart';
import 'presentation/widgets/reusable_widgets.dart';

void main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load SharedPreferences ahead of Riverpod scope initialization
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the loaded SharedPreferences instance into the provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const ParfumIQApp(),
    ),
  );
}

class ParfumIQApp extends ConsumerWidget {
  const ParfumIQApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch custom accent color index
    final accentIndex = ref.watch(accentColorIndexProvider);
    
    // Dynamically apply selected brand color
    AppTheme.accentGold = AppTheme.accentColors[accentIndex];
    AppTheme.brightGold = AppTheme.brightColors[accentIndex];

    // Watch the GoRouter configurations provider
    final router = ref.watch(routerProvider);

    // Watch the theme mode index (0: System, 1: Light, 2: Dark)
    final themeIndex = ref.watch(themeModeIndexProvider);
    final themeMode = themeIndex == 1
        ? ThemeMode.light
        : themeIndex == 2
            ? ThemeMode.dark
            : ThemeMode.system;

    final activeBrightness = themeMode == ThemeMode.light 
        ? Brightness.light 
        : (themeMode == ThemeMode.dark 
            ? Brightness.dark 
            : MediaQuery.platformBrightnessOf(context));
            
    final isDark = activeBrightness == Brightness.dark;

    // If in Light Mode and selected color is Cream (4) or White (5), auto reset to Indigo (0)
    if (!isDark && (accentIndex == 4 || accentIndex == 5)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(accentColorIndexProvider.notifier).setAccentColorIndex(0);
      });
    }

    return MaterialApp.router(
      title: 'Parfüm IQ',
      debugShowCheckedModeBanner: false,
      
      // Theme settings
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        return ElegantDiagonalBackground(child: child ?? SizedBox());
      },

      // Routing configuration
      routerConfig: router,
    );
  }
}
