import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/scent_profile_model.dart';
import '../widgets/reusable_widgets.dart';

class ScentProfileResultScreen extends ConsumerWidget {
  const ScentProfileResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(scentTestResultProvider);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('KOKU PROFİLİNİZ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Henüz koku profili testi yapmadınız.',
                style: GoogleFonts.outfit(color: AppTheme.textMuted),
              ),
              SizedBox(height: 16),
              PremiumButton(
                text: 'Koku Testine Başla',
                isFullWidth: false,
                onPressed: () => context.go('/test'),
              ),
            ],
          ),
        ),
      );
    }

    final profile = ScentProfileModel.fromJson(result['profile']);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppTheme.accentGold),
        title: Text(
          'KOKU PROFİLİNİZ',
          style: GoogleFonts.outfit(color: AppTheme.accentGold, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profile Logo Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.accentGold, width: 2),
                  gradient: RadialGradient(
                    colors: isDark
                        ? [const Color(0xFF3D3224), AppTheme.primaryBlack]
                        : [const Color(0xFFFFF9E6), Colors.white],
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppTheme.accentGold,
                  size: 50,
                ),
              ),
              SizedBox(height: 24),
              // Profile Name
              Text(
                profile.profileName.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 12),
              // Slogan block
              Text(
                '"Parfüm zevki tesadüf değildir."',
                style: GoogleFonts.outfit(
                  color: isDark 
                      ? AppTheme.bgCream.withOpacity(0.6) 
                      : AppTheme.primaryBlack.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 30),
              
              // Details Card
              Card(
                color: isDark ? AppTheme.secondaryBlack : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isDark ? AppTheme.darkBrown : AppTheme.borderGray, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Explanation
                      Text(
                        profile.shortExplanation,
                        style: GoogleFonts.outfit(
                          color: isDark ? AppTheme.textLight : AppTheme.textDark,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      Divider(color: isDark ? AppTheme.darkBrown : AppTheme.borderGray, height: 30),
                      
                      // Occasions
                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_month_outlined,
                        title: 'En İyi Kullanım Senaryoları',
                        content: profile.bestOccasions.join(', '),
                      ),
                      SizedBox(height: 20),
                      
                      // Personality
                      _buildDetailRow(
                        context,
                        icon: Icons.psychology_outlined,
                        title: 'Koku Kişiliğin',
                        content: profile.scentPersonality,
                      ),
                      SizedBox(height: 20),
                      
                      // Scent direction
                      _buildDetailRow(
                        context,
                        icon: Icons.explore_outlined,
                        title: 'Önerilen ScentIQ Yönü',
                        content: profile.recommendedDirection,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 36),
              
              // CTA Buttons
              PremiumButton(
                text: 'Önerilen Parfümleri Gör',
                icon: Icons.check_circle_outline_outlined,
                onPressed: () => context.push('/recommendations'),
              ),
              SizedBox(height: 12),
              PremiumButton(
                text: 'Testi Tekrarla',
                isSecondary: true,
                onPressed: () {
                  ref.read(scentTestResponseProvider.notifier).resetTest();
                  context.push('/test');
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.accentGold, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.accentGold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark 
                      ? AppTheme.bgCream.withOpacity(0.8) 
                      : AppTheme.textDark.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
