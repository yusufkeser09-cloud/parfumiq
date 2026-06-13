import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class RecommendationScreen extends ConsumerWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(scentTestResultProvider);
    final favList = ref.watch(favoritesProvider);

    if (result == null || result['recommendations'] == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ÖNERİLERİNİZ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Henüz koku testi yapmadınız.',
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

    final recommendationsJson = result['recommendations'] as List;
    final recommendations = recommendationsJson.map((p) => PerfumeModel.fromJson(p)).toList();

    final roles = [
      'Ana Parfüm Önerisi',
      'Bütçe Dostu (Cheaper) Alternatif',
      'Premium (Lüks) Alternatif',
      'Sıra Dışı (Unique) Seçenek',
      'Katmanlama (Layering) Tavsiyesi',
    ];

    final roleExplanations = [
      'Profilinize ve kullanım amacınıza en uygun ana koku seçimi.',
      'Benzer koku profiline sahip, cebinizi yormayacak alternatif.',
      'Daha lüks, niş ve yüksek kaliteli bir sürüm seçeneği.',
      'Aynı grupta ama daha nadir ve karakter sahibi bir alternatif.',
      'Bu parfümle birleştirildiğinde koku profilini derinleştiren tazeleyici dokunuş.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SCENTIQ ÖNERİLERİ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Senin İçin Seçilen 5 Koku',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 22,
                    ),
              ),
              SizedBox(height: 4),
              Text(
                'Davud ScentIQ algoritması tarafından zevklerinize göre sıralanmıştır.',
                style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13),
              ),
              SizedBox(height: 20),
              
              // Recommendations List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final perfume = recommendations[index];
                  final isFav = favList.contains(perfume.id);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlack,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            roles[index].toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        // Role Description Note
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          color: AppTheme.accentGold.withOpacity(0.05),
                          child: Text(
                            roleExplanations[index],
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        // Perfume Card
                        PerfumeCard(
                          perfume: perfume,
                          isFavorite: isFav,
                          onFavoriteTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(perfume.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 12),
              
              // Affiliate disclosure
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.borderGray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderGray.withOpacity(0.3)),
                ),
                child: Text(
                  '💡 Bazı bağlantılar affiliate link olabilir. Bu öneriler tamamen güvenilirlik ilkesine göre yapılır, markaların sponsorluğuyla belirlenmez.',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
