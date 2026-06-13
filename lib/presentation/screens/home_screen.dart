import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final favList = ref.watch(favoritesProvider);
    final testResult = ref.watch(scentTestResultProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Scent profile calculations
    final favoriteIds = favList;
    final List<PerfumeModel> perfumesToAnalyze = [];
    if (favoriteIds.isEmpty) {
      // If no favorites, use a default list of perfumes (e.g., featured ones) to show a nice initial balanced state
      perfumesToAnalyze.addAll([
        repo.getById('creed_aventus'),
        repo.getById('dior_sauvage_elixir'),
        repo.getById('bleu_de_chanel'),
      ].whereType<PerfumeModel>());
    } else {
      for (final id in favoriteIds) {
        final p = repo.getById(id);
        if (p != null) {
          perfumesToAnalyze.add(p);
        }
      }
    }

    double scoreFerah = 0;
    double scoreTatli = 0;
    double scoreOud = 0;
    double scoreOdunsu = 0;
    double scoreBaharatli = 0;

    for (final p in perfumesToAnalyze) {
      scoreFerah += p.freshnessLevel;
      scoreTatli += p.sweetnessLevel;
      scoreOdunsu += p.woodyLevel;
      scoreBaharatli += p.spicyLevel;

      final isOud = p.name.toLowerCase().contains('oud') ||
          p.name.toLowerCase().contains('ud') ||
          p.fragranceFamily.toLowerCase().contains('oryantal') ||
          p.tags.join(' ').toLowerCase().contains('tütsü') ||
          p.tags.join(' ').toLowerCase().contains('ud') ||
          p.davudComment.toLowerCase().contains('tütsü') ||
          p.davudComment.toLowerCase().contains('ud');
      scoreOud += isOud ? 5.0 : 1.0;
    }

    final totalScore = scoreFerah + scoreTatli + scoreOud + scoreOdunsu + scoreBaharatli;
    final pctFerah = totalScore > 0 ? (scoreFerah / totalScore * 100) : 20.0;
    final pctTatli = totalScore > 0 ? (scoreTatli / totalScore * 100) : 20.0;
    final pctOud = totalScore > 0 ? (scoreOud / totalScore * 100) : 20.0;
    final pctOdunsu = totalScore > 0 ? (scoreOdunsu / totalScore * 100) : 20.0;
    final pctBaharatli = totalScore > 0 ? (scoreBaharatli / totalScore * 100) : 20.0;

    final List<_ScentBarData> categories = [
      _ScentBarData('Ferah', pctFerah),
      _ScentBarData('Tatlı', pctTatli),
      _ScentBarData('Oud', pctOud),
      _ScentBarData('Odunsu', pctOdunsu),
      _ScentBarData('Baharatlı', pctBaharatli),
    ];

    categories.sort((a, b) => b.percentage.compareTo(a.percentage));

    final topCategory = categories[0];
    final remaining = categories.sublist(1);

    final List<_ScentBarData> displayed = List.generate(5, (_) => _ScentBarData('', 0));
    displayed[2] = topCategory;
    displayed[0] = remaining[0];
    displayed[1] = remaining[1];
    displayed[3] = remaining[2];
    displayed[4] = remaining[3];

    return Scaffold(
      appBar: AppBar(
        title: const ParfumIQWordmarkLogo(size: 26),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: AppTheme.accentGold),
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AppTheme.accentGold),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              Text(
                'Bugün sana yakışan kokuyu bulalım.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                      height: 1.2,
                    ),
              ),
              SizedBox(height: 16),

              // Main CTA Banner: Scent Profile Test
              InteractiveScale(
                onTap: () {
                  if (testResult != null) {
                    context.push('/result');
                  } else {
                    context.push('/test');
                  }
                },
                child: Container(
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'AI DANIŞMAN',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              testResult != null ? 'Koku Profilin Hazır!' : 'Kişisel Koku Profilini Çıkar',
                              style: GoogleFonts.outfit(
                                color: isDark ? AppTheme.cleanWhite : AppTheme.primaryBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              testResult != null 
                                  ? 'ScentIQ analizi sonucunu ve özel önerileri görüntüle.'
                                  : 'Tarzını, bütçeni ve ten kimyanı analiz edip sana yakışan parfüm grubunu bulalım.',
                              style: GoogleFonts.outfit(
                                color: isDark 
                                    ? AppTheme.bgCream.withOpacity(0.7) 
                                    : AppTheme.primaryBlack.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: AppTheme.accentGold,
                        radius: 20,
                        child: Icon(
                          Icons.arrow_forward, 
                          color: isDark ? AppTheme.primaryBlack : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Quick Actions Grid (SectionHeader + Actions)
              const SectionHeader(title: 'Hızlı İşlemler'),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickActionCard(
                    context,
                    title: 'Parfüm Öner',
                    subtitle: 'AI Destekli Koku Bul',
                    icon: Icons.auto_awesome_outlined,
                    onTap: () => context.push('/test'),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Dupe Bul',
                    subtitle: 'Alternatif Koku Keşfet',
                    icon: Icons.find_replace_outlined,
                    onTap: () => context.push('/dupes'),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Hediye Seç',
                    subtitle: 'Sevdiklerine Özel Hediye',
                    icon: Icons.card_giftcard_outlined,
                    onTap: () => context.push('/gift'),
                  ),
                  _buildQuickActionCard(
                    context,
                    title: 'Dolabımı Analiz Et',
                    subtitle: 'Koleksiyon Eksiklerini Gör',
                    icon: Icons.layers_outlined,
                    onTap: () => context.push('/wardrobe'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildFullWidthActionCard(
                context,
                title: 'Bugün Ne Sıkılır?',
                subtitle: 'Hava durumuna ve planına uygun günlük koku önerisi al.',
                icon: Icons.wb_sunny_outlined,
                onTap: () => context.push('/daily-suggestion'),
              ),
              SizedBox(height: 24),



              // Scent Profile Analysis Section
              if (favList.isNotEmpty) ...[
                const SectionHeader(
                  title: "Kişisel Koku Profili Tercihleri",
                  subtitle: "Favorilediğiniz parfümlere göre koku tercih yoğunluğunuz",
                ),
                const SizedBox(height: 8),
                Card(
                  color: isDark ? AppTheme.secondaryBlack : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kişiselleştirilmiş koku tercih oranlarınız:',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 220,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(5, (index) {
                              final item = displayed[index];
                              final isMiddle = index == 2;
                              
                              final barColor = isMiddle 
                                  ? AppTheme.accentGold 
                                  : AppTheme.accentGold.withOpacity(0.4);
                              
                              return _buildScentBar(
                                context: context,
                                name: item.name,
                                percentage: item.percentage,
                                barColor: barColor,
                                isMiddle: isMiddle,
                                isDark: isDark,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: PremiumBottomNavigationBar(
        currentIndex: 0,
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

  Widget _buildQuickActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InteractiveScale(
      onTap: onTap,
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: isDark ? AppTheme.secondaryBlack : AppTheme.cleanWhite,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppTheme.accentGold, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InteractiveScale(
      onTap: onTap,
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: isDark ? AppTheme.secondaryBlack : AppTheme.cleanWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.accentGold, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.accentGold),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScentBar({
    required BuildContext context,
    required String name,
    required double percentage,
    required Color barColor,
    required bool isMiddle,
    required bool isDark,
  }) {
    final pctText = '${percentage.toStringAsFixed(1)}%';

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Percentage Text
          if (isMiddle)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.accentGold,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                pctText,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: (barColor == Colors.white || barColor == const Color(0xFFF7F4EB)) 
                      ? Colors.black 
                      : Colors.white,
                ),
              ),
            )
          else
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: GoogleFonts.outfit(
                fontSize: 9,
                color: AppTheme.textMuted.withOpacity(0.7),
              ),
            ),
          const SizedBox(height: 6),
          // Long rectangle bar (as requested: "uzun dikdörtgen şeklinde")
          Container(
            width: 22,
            height: 150 * (percentage / 100).clamp(0.12, 1.0),
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(1), // minimal rounding for clean rectangular shape
              boxShadow: [
                BoxShadow(
                  color: barColor.withOpacity(0.25),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Scent Label
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: isMiddle ? FontWeight.bold : FontWeight.normal,
              color: isMiddle
                  ? AppTheme.accentGold
                  : (isDark ? AppTheme.cleanWhite : AppTheme.primaryBlack),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScentBarData {
  final String name;
  final double percentage;
  _ScentBarData(this.name, this.percentage);
}
