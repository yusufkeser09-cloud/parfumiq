import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../../data/repositories/perfume_repository.dart';
import '../widgets/reusable_widgets.dart';
import '../widgets/brand_logo_widget.dart';

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  void _showBrandPerfumesBottomSheet(BuildContext context, WidgetRef ref, String brand) {
    final repo = ref.read(perfumeRepositoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandPerfumes = repo.getAll().where((p) => p.brand.toLowerCase() == brand.toLowerCase()).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.secondaryBlack : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            final currentOwnedIds = ref.watch(wardrobeProvider);
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  brand.toUpperCase(),
                                  style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
                                ),
                                Text(
                                  'Tüm Koleksiyon Parfümleri',
                                  style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: brandPerfumes.length,
                          itemBuilder: (context, index) {
                            final perfume = brandPerfumes[index];
                            final isOwned = currentOwnedIds.contains(perfume.id);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                title: Text(perfume.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text(
                                  '${perfume.fragranceFamily} • ${perfume.season.join(", ")}',
                                  style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 11),
                                ),
                                trailing: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: IconButton(
                                    key: ValueKey('${perfume.id}_$isOwned'),
                                    icon: Icon(
                                      isOwned ? Icons.check_circle : Icons.add_circle_outline,
                                      color: isOwned ? AppTheme.accentGold : AppTheme.textMuted,
                                    ),
                                    onPressed: () {
                                      if (isOwned) {
                                        ref.read(wardrobeProvider.notifier).removePerfume(perfume.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${perfume.name} dolaptan kaldırıldı.')),
                                        );
                                      } else {
                                        ref.read(wardrobeProvider.notifier).addPerfume(perfume.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${perfume.name} dolabınıza eklendi.')),
                                        );
                                      }
                                      setStateBottomSheet(() {});
                                    },
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/perfume/${perfume.id}');
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final ownedIds = ref.watch(wardrobeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final ownedPerfumes = ownedIds.map((id) => repo.getById(id)).whereType<PerfumeModel>().toList();
    final analysisResult = repo.analyzeWardrobe(ownedPerfumes);

    PerfumeModel? suggestedNextPurchase;
    if (analysisResult.contains('yaz kokusu') || analysisResult.contains('Yazlık')) {
      suggestedNextPurchase = repo.getById('acqua_di_gio_profondo');
    } else if (analysisResult.contains('kış kokusu') || analysisResult.contains('kış için')) {
      suggestedNextPurchase = repo.getById('le_male_le_parfum');
    } else if (analysisResult.contains('ofise uygun') || analysisResult.contains('ofis')) {
      suggestedNextPurchase = repo.getById('montblanc_explorer');
    } else if (analysisResult.contains('date') || analysisResult.contains('buluşmalar')) {
      suggestedNextPurchase = repo.getById('la_nuit_de_lhomme');
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PARFÜM DOLABIM'),
          bottom: TabBar(
            tabs: [
              Tab(
                child: InteractiveScale(
                  enableHoverBackground: true,
                  child: Text('Koleksiyonum'),
                ),
              ),
              Tab(
                child: InteractiveScale(
                  enableHoverBackground: true,
                  child: Text('ScentIQ Analizi'),
                ),
              ),
            ],
            labelColor: AppTheme.accentGold,
            unselectedLabelColor: AppTheme.textMuted,
            indicatorColor: AppTheme.accentGold,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildCollectionTab(context, ref, ownedPerfumes, repo),
            _buildAnalysisTab(context, ref, analysisResult, suggestedNextPurchase, isDark),
          ],
        ),
        bottomNavigationBar: PremiumBottomNavigationBar(
          currentIndex: 3,
          onTap: (index) {
            if (index == 0) context.go('/home');
            if (index == 1) context.go('/favorites');
            if (index == 2) context.go('/premium');
            if (index == 3) context.go('/wardrobe');
            if (index == 4) context.go('/settings');
          },
        ),
      ),
    );
  }

  Widget _buildCollectionTab(BuildContext context, WidgetRef ref, List<PerfumeModel> ownedPerfumes, PerfumeRepository repo) {
    final brands = repo.getAll().map((p) => p.brand).toSet().toList()..sort();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ownedPerfumes.isNotEmpty) ...[
            Text(
              'DOLABIMDAKİ PARFÜMLER (${ownedPerfumes.length})',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentGold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ownedPerfumes.length,
              itemBuilder: (context, index) {
                final perfume = ownedPerfumes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      perfume.name,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(perfume.brand, style: GoogleFonts.outfit(color: AppTheme.accentGold, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                perfume.fragranceFamily,
                                style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.accentGold),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              perfume.season.join(', '),
                              style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.statusDanger),
                      onPressed: () {
                        ref.read(wardrobeProvider.notifier).removePerfume(perfume.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${perfume.name} dolaptan kaldırıldı.')),
                        );
                      },
                    ),
                    onTap: () => context.push('/perfume/${perfume.id}'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),
          ],

          Text(
            'PARFÜM MARKALARI (${brands.length})',
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentGold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final brandPerfumes = repo.getAll().where((p) => p.brand.toLowerCase() == brand.toLowerCase()).toList();
              return _buildBrandCard(context, ref, brand, brandPerfumes.length, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrandCard(BuildContext context, WidgetRef ref, String brand, int perfumeCount, bool isDark) {
    final accentColor = AppTheme.accentGold;
    return InteractiveScale(
      onTap: () => _showBrandPerfumesBottomSheet(context, ref, brand),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.secondaryBlack : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: BrandLogoWidget(brand: brand, color: accentColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              brand.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: isDark ? Colors.white : AppTheme.primaryBlack,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$perfumeCount Parfüm',
              style: GoogleFonts.outfit(
                fontSize: 10.5,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisTab(
    BuildContext context,
    WidgetRef ref,
    String analysisText,
    PerfumeModel? suggestedNext,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.query_stats_outlined, color: AppTheme.accentGold),
                    SizedBox(width: 8),
                    Text(
                      'ScentIQ Dolap Analiz Sonucu',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.accentGold),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  analysisText,
                  style: GoogleFonts.outfit(fontSize: 13, height: 1.5, color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          if (suggestedNext != null) ...[
            Text(
              'Önerilen Bir Sonraki Alışverişin',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold, letterSpacing: 1),
            ),
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlack,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Text(
                'DOLAP EKSİĞİNİ KAPATACAK EN İYİ SEÇENEK',
                style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
              ),
            ),
            PerfumeCard(perfume: suggestedNext),
          ],
        ],
      ),
    );
  }
}
