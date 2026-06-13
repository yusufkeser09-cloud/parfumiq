import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../widgets/reusable_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Sana Yakışan\nKokuyu Bul',
      'description': 'Kendi tarzına, bütçene ve ten kimyana uygun mükemmel parfümleri keşfet. Parfüm seçerken şansa güvenme.',
      'tagline': 'Davud ScentIQ ile Keşfet',
    },
    {
      'title': 'AI ile Kişisel\nKoku Profilini Çıkar',
      'description': 'Akıllı koku analizi sayesinde yaşın, kullanım senaryon ve zevklerin doğrultusunda sana en uygun koku grubunu belirle.',
      'tagline': 'Gelişmiş Koku Eşleştirme',
    },
    {
      'title': 'Her Duruma\nDoğru Seçim',
      'description': 'Ofis, date, gece kulübü, yazlık veya kışlık... Hangi mevsimde nerede ne sıkman gerektiğini doğrudan öğren.',
      'tagline': 'Pratik ve Net Kararlar',
    },
    {
      'title': 'Parfüm Zevki\nTesadüf Değildir',
      'description': 'Pahalı niş parfümlerden, bütçe dostu benzer koku profillerine kadar aradığın tüm alternatifler burada.',
      'tagline': 'Davud ScentIQ Güvencesi',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _finishOnboarding(bool startTest) {
    ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
    if (startTest) {
      context.go('/test');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ParfumIQLogo(size: 24),
                  TextButton(
                    onPressed: () => _finishOnboarding(false),
                    child: Text(
                      'Atla',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Page Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        // Animated Logo in the center
                        AnimatedOnboardingLogo(size: 110),
                        const SizedBox(height: 36),
                        // Centered Title
                        Text(
                          data['title']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: AppTheme.cleanWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const Spacer(flex: 3),
                        // Centered description at the bottom
                        Text(
                          data['description']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: AppTheme.bgCream.withOpacity(0.85),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppTheme.accentGold : AppTheme.darkBrown,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Buttons
                  if (_currentPage == _onboardingData.length - 1)
                    PremiumButton(
                      text: 'Koku Testine Başla',
                      icon: Icons.assignment_outlined,
                      onPressed: () => _finishOnboarding(true),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 48), // Spacer
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            foregroundColor: AppTheme.primaryBlack,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedOnboardingLogo extends StatefulWidget {
  final double size;
  const AnimatedOnboardingLogo({Key? key, this.size = 120.0}) : super(key: key);

  @override
  State<AnimatedOnboardingLogo> createState() => _AnimatedOnboardingLogoState();
}

class _AnimatedOnboardingLogoState extends State<AnimatedOnboardingLogo>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  late AnimationController _floatingController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Entrance animation (scale up with elastic back-bounce + fade in)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.elasticOut, // Spring bounce like Duolingo
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // 2. Slow floating animation
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _floatingController,
        curve: Curves.easeInOut,
      ),
    );

    // Play entrance and then loop float
    _entranceController.forward().then((_) {
      if (mounted) {
        _floatingController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_entranceController, _floatingController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: ParfumIQLogo(size: widget.size),
            ),
          ),
        );
      },
    );
  }
}
