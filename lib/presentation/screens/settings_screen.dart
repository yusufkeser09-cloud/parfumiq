import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../widgets/reusable_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _deleteUserData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.secondaryBlack,
          title: Text(
            'Verilerimi Sil',
            style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Tüm favorileriniz, koku dolabınız ve AI test verileriniz cihazınızdan tamamen silinecektir. Bu işlem geri alınamaz.',
            style: GoogleFonts.outfit(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İPTAL', style: GoogleFonts.outfit(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Clear all providers/prefs
                ref.read(onboardingCompletedProvider.notifier).resetOnboarding();
                ref.read(scentTestResponseProvider.notifier).resetTest();
                ref.read(scentTestResultProvider.notifier).clear();
                ref.read(favoritesProvider.notifier).clear();
                ref.read(wardrobeProvider.notifier).clear();
                ref.read(accentColorIndexProvider.notifier).reset();
                ref.read(themeModeIndexProvider.notifier).reset();
                ref.read(isPremiumProvider.notifier).reset();
                
                // Close and redirect
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tüm kullanıcı verileriniz başarıyla silindi.')),
                );
                context.go('/onboarding');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              child: Text('VERİLERİ SİL', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentIndex = ref.watch(accentColorIndexProvider);

    // If in Light Mode and selected color is Cream (4) or White (5), auto reset to Indigo (0)
    if (!isDark && (accentIndex == 4 || accentIndex == 5)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(accentColorIndexProvider.notifier).setAccentColorIndex(0);
      });
    }

    final testResult = ref.watch(scentTestResultProvider);
    final onboardingCompleted = ref.watch(onboardingCompletedProvider);
    final isPremium = ref.watch(isPremiumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AYARLAR'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              Card(
                color: isDark ? AppTheme.secondaryBlack : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.accentGold,
                        radius: 28,
                        child: Text(
                          'U',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlack,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parfüm Sever',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'parfumsever@scentiq.com',
                              style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPremium ? 'PREMIUM ÜYE' : 'STANDART ÜYE',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Visual Customization section
              const SectionHeader(title: 'Görsel Özelleştirme'),
              Card(
                color: isDark ? AppTheme.secondaryBlack : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uygulama Teması Vurgu Rengi:',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(AppTheme.accentColors.length, (index) {
                          final color = AppTheme.accentColors[index];
                          final isSelected = ref.watch(accentColorIndexProvider) == index;
                          final isDisabled = !isDark && (index == 4 || index == 5);
                          
                          return GestureDetector(
                            onTap: isDisabled 
                                ? null 
                                : () {
                                    ref.read(accentColorIndexProvider.notifier).setAccentColorIndex(index);
                                  },
                            child: Opacity(
                              opacity: isDisabled ? 0.35 : 1.0,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isDisabled ? Colors.grey[300] : color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? (isDark ? Colors.white : AppTheme.primaryBlack)
                                        : (isDisabled ? Colors.grey : Colors.transparent),
                                    width: 2.5,
                                  ),
                                  boxShadow: isDisabled ? null : [
                                    BoxShadow(
                                      color: color.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: (index == 1 || index == 4 || index == 5) ? Colors.black : Colors.white,
                                        size: 20,
                                      )
                                    : (isDisabled
                                        ? const Icon(
                                            Icons.block,
                                            color: Colors.grey,
                                            size: 16,
                                          )
                                        : null),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: AppTheme.borderGray),
                      const SizedBox(height: 16),
                      Text(
                        'Uygulama Teması Görünümü:',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildThemeSegmentButton(context, ref, 0, 'Sistem', Icons.brightness_auto, isDark),
                          const SizedBox(width: 8),
                          _buildThemeSegmentButton(context, ref, 1, 'Açık', Icons.light_mode, isDark),
                          const SizedBox(width: 8),
                          _buildThemeSegmentButton(context, ref, 2, 'Koyu', Icons.dark_mode, isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),



              // Legal / Affiliate Disclosure
              const SectionHeader(title: 'Güvenilirlik ve Ortaklık Bildirimi'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.secondaryBlack : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderGray.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ScentIQ Dürüstlük İlkesi:',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.accentGold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Parfüm IQ uygulamasındaki tüm koku yorumları, karar dereceleri (Alınır/Alınmaz/Fiyatına Değmez) tamamen bağımsızdır ve Davud ScentIQ markasının parfümcülük standartlarına göre belirlenmiştir.\n\nBazı yönlendirme butonları (affiliate) satın alma bağlantıları içerebilir. Bu ortaklıklar tavsiyelerimizi etkilemez.',
                      style: GoogleFonts.outfit(fontSize: 12, height: 1.5, color: isDark ? Colors.grey[300] : Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Debug / Reset Options
              const SectionHeader(title: 'Geliştirici & Test Seçenekleri'),
              ListTile(
                leading: Icon(Icons.refresh, color: AppTheme.accentGold),
                title: Text('Koku Testini Sıfırla', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                subtitle: Text('Profil test sonuçlarını cihazdan siler.', style: GoogleFonts.outfit(fontSize: 11)),
                onTap: () {
                  ref.read(scentTestResultProvider.notifier).clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Koku profili testiniz sıfırlandı.')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings_backup_restore, color: AppTheme.accentGold),
                title: Text('Onboarding Ekranını Sıfırla', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                subtitle: Text('Başlangıç tanıtım ekranlarını tekrar etkinleştirir.', style: GoogleFonts.outfit(fontSize: 11)),
                onTap: () {
                  ref.read(onboardingCompletedProvider.notifier).resetOnboarding();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Onboarding sıfırlandı. Uygulamayı yeniden başlatabilirsiniz.')),
                  );
                },
              ),
              const Divider(),
              SizedBox(height: 12),

              // Compliance: Data deletion
              const SectionHeader(title: 'Yasal Hükümler'),
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.redAccent),
                title: Text('Hesabımı ve Verilerimi Sil', style: GoogleFonts.outfit(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                subtitle: Text('Cihazdaki tüm kişisel verilerinizi kalıcı olarak temizler.', style: GoogleFonts.outfit(fontSize: 11)),
                onTap: () => _deleteUserData(context, ref),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PremiumBottomNavigationBar(
        currentIndex: 4,
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

  Widget _buildThemeSegmentButton(
    BuildContext context,
    WidgetRef ref,
    int index,
    String label,
    IconData icon,
    bool isDark,
  ) {
    final selectedIndex = ref.watch(themeModeIndexProvider);
    final isSelected = selectedIndex == index;

    final activeBg = AppTheme.accentGold.withOpacity(0.15);
    final inactiveBg = isDark ? AppTheme.primaryBlack : AppTheme.bgCream.withOpacity(0.5);
    final activeBorderColor = AppTheme.accentGold;
    final inactiveBorderColor = isDark ? AppTheme.darkBrown : AppTheme.borderGray.withOpacity(0.5);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(themeModeIndexProvider.notifier).setThemeModeIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : inactiveBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeBorderColor : inactiveBorderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppTheme.accentGold : (isDark ? AppTheme.textMuted : Colors.grey[700]),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppTheme.accentGold : (isDark ? AppTheme.textLight : AppTheme.primaryBlack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
