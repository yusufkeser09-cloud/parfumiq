import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../widgets/reusable_widgets.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ParfumIQWordmarkLogo(size: 26),
            const SizedBox(height: 1),
            Text(
              'PREMIUM',
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGold,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Premium Gold Logo
              Icon(Icons.workspace_premium, color: AppTheme.accentGold, size: 70),
              const SizedBox(height: 16),
              
              // Paywall Header
              Text(
                'PREMIUM ÜYELİK',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Koku Tarzınızı Kusursuzlaştırın',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.primaryBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Parfüm zevki tesadüf değildir. Davud ScentIQ AI danışmanı ile her an yanınızda.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: AppTheme.textMuted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Status Card showing it is Active/Unlocked
              isPremium
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.secondaryBlack : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppTheme.accentGold : AppTheme.accentGold.withOpacity(0.5), 
                          width: 1.5,
                        ),
                        gradient: LinearGradient(
                          colors: isDark
                              ? [AppTheme.primaryBlack, Color.lerp(AppTheme.primaryBlack, AppTheme.accentGold, 0.15)!]
                              : [Colors.white, Color.lerp(Colors.white, AppTheme.accentGold, 0.06)!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.accentGold.withOpacity(isDark ? 0.15 : 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified, color: AppTheme.accentGold, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'PREMIUM AKTİF',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentGold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tüm ayrıcalıklı özellikler ömür boyu ve ücretsiz olarak hesabınızda tanımlanmıştır.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: isDark 
                                  ? AppTheme.cleanWhite.withOpacity(0.9) 
                                  : AppTheme.primaryBlack.withOpacity(0.8),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.secondaryBlack : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.5), 
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.redAccent, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            'PREMIUM ÜYELİK PASİF',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kullanıcı verilerinizi sildiğiniz için Premium özellikler pasif hale getirilmiştir.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white70 : AppTheme.primaryBlack.withOpacity(0.7),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(isPremiumProvider.notifier).setPremium(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Premium üyeliğiniz başarıyla yeniden aktifleştirildi!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentGold,
                              foregroundColor: AppTheme.primaryBlack,
                            ),
                            child: Text(
                              'PREMIUM ÜYELİĞİ AKTİFLEŞTİR',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 24),

              // Feature Table/List Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aktif Ayrıcalıklarınız',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Feature Table/List
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.secondaryBlack : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? AppTheme.darkBrown : AppTheme.borderGray, width: 1),
                ),
                child: Column(
                  children: [
                    _buildFeatureRow('Sınırsız AI Koku Danışmanlığı', isDark),
                    _buildFeatureRow('Alternatif (Dupe) Bulucu & Analizler', isDark),
                    _buildFeatureRow('Detaylı Dolap Analizi ve Eksen Eksikleri', isDark),
                    _buildFeatureRow('Hediye Modu Önerileri ve Tüyolar', isDark),
                    _buildFeatureRow('Koku Katmanlama (Layering) Formülleri', isDark),
                    _buildFeatureRow('Niş Markalar ve Özel Koku Raporu', isDark),
                    _buildFeatureRow('Reklamsız Deneyim', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PremiumBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/favorites');
          if (index == 2) context.go('/premium');
          if (index == 3) context.go('/wardrobe');
          if (index == 4) context.go('/settings');
        },
      ),
    );
  }

  Widget _buildFeatureRow(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.accentGold,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                color: isDark ? Colors.white : AppTheme.primaryBlack,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
