import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../widgets/reusable_widgets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late String _randomTip;

  final List<String> _tips = [
    "Parfümünüzü duştan hemen sonra, cilt gözenekleri açıkken sıkarsanız kalıcılığı artar.",
    "Parfüm sıktıktan sonra bileklerinizi birbirine sürtmeyin; bu koku moleküllerini bozabilir.",
    "Kuru ciltler parfümü daha az tutar. Kalıcılığı artırmak için kokusuz nemlendirici kullanabilirsiniz.",
    "Parfümleri doğrudan güneş ışığı alan ve nemli banyo ortamlarında saklamak kokuyu bozebilir.",
    "Narenciye notaları hızlı uçarken; ud, vanilya ve odunsu notalar tende en uzun süre kalan dip notalardır.",
    "Nabız noktaları (boyun, bilekler, kulak arkası) vücudun en sıcak yerleridir ve kokunun yayılımını artırır.",
    "Parfümü saç fırçanıza sıktıktan sonra saçınızı tarayarak kokunun gün boyu saçınızda kalmasını sağlayabilirsiniz.",
    "Koku katmanlama (layering) ile iki farklı parfümü üst üste sıkıp kendinize özgün bir koku yaratabilirsiniz.",
    "Parfümün yayılımı ve kalıcılığı ten kimyanıza, sıcaklığa ve ortamın nem oranına göre değişir.",
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Select random tip based on microseconds
    _randomTip = _tips[DateTime.now().microsecond % _tips.length];

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for animation to finish and then route
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final onboardingCompleted = ref.read(onboardingCompletedProvider);
    if (onboardingCompleted) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Clean vectorized wordmark logo matching the second image (dynamically colored)
              const ParfumIQWordmarkLogo(size: 110),
              const SizedBox(height: 50),
              // Signature Phrase / Dynamic Tip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  _randomTip,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.bgCream.withOpacity(0.75),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
