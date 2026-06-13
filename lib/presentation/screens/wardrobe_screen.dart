import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class WardrobeScreen extends ConsumerWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  void _showAddPerfumeDialog(BuildContext context, WidgetRef ref) {
    final repo = ref.read(perfumeRepositoryProvider);
    final ownedIds = ref.read(wardrobeProvider);
    final allPerfumes = repo.getAll().where((p) => !ownedIds.contains(p.id)).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.secondaryBlack : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Parfüm Ekle',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
              ),
              SizedBox(height: 12),
              if (allPerfumes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text('Eklenebilecek yeni parfüm yok.', style: GoogleFonts.outfit(color: AppTheme.textMuted)),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: allPerfumes.length,
                    itemBuilder: (context, index) {
                      final perfume = allPerfumes[index];
                      return ListTile(
                        title: Text(perfume.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                        subtitle: Text(perfume.brand, style: GoogleFonts.outfit(color: AppTheme.textMuted)),
                        trailing: Icon(Icons.add, color: AppTheme.accentGold),
                        onTap: () {
                          ref.read(wardrobeProvider.notifier).addPerfume(perfume.id);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${perfume.name} dolabınıza eklendi.')),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final ownedIds = ref.watch(wardrobeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Resolve model instances
    final ownedPerfumes = ownedIds.map((id) => repo.getById(id)).whereType<PerfumeModel>().toList();

    // Call wardrobe advisor analyzer
    final analysisResult = repo.analyzeWardrobe(ownedPerfumes);

    // Suggest next purchase based on analysis results
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
            // Tab 1: Collection list
            _buildCollectionTab(context, ref, ownedPerfumes),
            // Tab 2: Wardrobe Analysis
            _buildAnalysisTab(context, ref, analysisResult, suggestedNextPurchase, isDark),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            // Hide FAB on analysis tab
            return FloatingActionButton(
              onPressed: () => _showAddPerfumeDialog(context, ref),
              backgroundColor: AppTheme.accentGold,
              foregroundColor: AppTheme.primaryBlack,
              child: Icon(Icons.add),
            );
          }
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

  Widget _buildCollectionTab(BuildContext context, WidgetRef ref, List<PerfumeModel> ownedPerfumes) {
    if (ownedPerfumes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.door_sliding_outlined, size: 60, color: AppTheme.accentGold.withOpacity(0.5)),
              SizedBox(height: 16),
              Text(
                'Dolabınız Boş',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Şu an sahip olduğunuz parfümleri ekleyerek koku dolabınızı oluşturun.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13),
              ),
              SizedBox(height: 24),
              PremiumButton(
                text: 'PARFÜM EKLE',
                isFullWidth: false,
                onPressed: () => _showAddPerfumeDialog(context, ref),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
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
                SizedBox(height: 4),
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
                    SizedBox(width: 8),
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
          // ScentIQ analysis output
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

          // Recommended Next Purchase card
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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
