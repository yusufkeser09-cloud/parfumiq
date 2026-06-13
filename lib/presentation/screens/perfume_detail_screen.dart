import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class PerfumeDetailScreen extends ConsumerWidget {
  final String perfumeId;

  const PerfumeDetailScreen({Key? key, required this.perfumeId}) : super(key: key);

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bağlantı açılamadı: $urlString')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final perfume = repo.getById(perfumeId);

    if (perfume == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hata')),
        body: const Center(
          child: Text('Aradığınız parfüm bulunamadı.'),
        ),
      );
    }

    final isFav = ref.watch(favoritesProvider).contains(perfume.id);
    final inWardrobe = ref.watch(wardrobeProvider).contains(perfume.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Elegant Header Sliver
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    perfume.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: isDark ? AppTheme.primaryBlack : AppTheme.bgCream,
                    ),
                  ),
                  // Dark overlay gradient to ensure readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppTheme.statusDanger : AppTheme.accentGold,
                ),
                onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(perfume.id),
              ),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Grid with Brand & Name in the center
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RiskBadge(risk: perfume.riskLevel),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              perfume.brand.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentGold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              perfume.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.cleanWhite : AppTheme.primaryBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      VerdictBadge(verdict: perfume.netVerdict),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Full Net Verdict sentence
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.secondaryBlack : AppTheme.bgCream,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: perfume.netVerdict.toLowerCase().contains('alınır')
                            ? AppTheme.statusSuccess.withOpacity(0.3)
                            : perfume.netVerdict.toLowerCase().contains('değmez') || perfume.netVerdict.toLowerCase().contains('alınmaz')
                                ? AppTheme.statusDanger.withOpacity(0.3)
                                : AppTheme.accentGold.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      perfume.netVerdict,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppTheme.cleanWhite : AppTheme.primaryBlack,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Wardrobe & Favorite Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (inWardrobe) {
                              ref.read(wardrobeProvider.notifier).removePerfume(perfume.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Parfüm dolaptan çıkarıldı.')),
                              );
                            } else {
                              ref.read(wardrobeProvider.notifier).addPerfume(perfume.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Parfüm dolabınıza eklendi.')),
                              );
                            }
                          },
                          icon: Icon(inWardrobe ? Icons.check : Icons.all_inbox_outlined),
                          label: Text(inWardrobe ? 'DOLABIMDA VAR' : 'DOLABIMA EKLE'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: inWardrobe ? AppTheme.darkBrown : AppTheme.accentGold,
                            foregroundColor: inWardrobe ? AppTheme.cleanWhite : AppTheme.primaryBlack,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Davud ScentIQ Comment Card
                  Card(
                    color: isDark ? AppTheme.secondaryBlack : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.accentGold,
                                radius: 14,
                                child: Text('D', style: TextStyle(color: AppTheme.primaryBlack, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Davud'un ScentIQ Yorumu",
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.accentGold),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            perfume.davudComment,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.5,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Scent Metrics Sliders (Sweet, Fresh, Woody, Spicy)
                  const SectionHeader(title: 'Koku Karakteri Değerleri'),
                  _buildMetricSlider('Temizlik / Ferahlık', perfume.freshnessLevel),
                  _buildMetricSlider('Tatlılık', perfume.sweetnessLevel),
                  _buildMetricSlider('Odunsuluk', perfume.woodyLevel),
                  _buildMetricSlider('Baharatlılık', perfume.spicyLevel),
                  
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoBlock('Kalıcılık', perfume.longevity),
                      _buildInfoBlock('Yayılım', perfume.projection),
                      _buildInfoBlock('Fiyat Seviyesi', perfume.priceBand),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Notes pyramid section
                  const SectionHeader(title: 'Koku Notaları'),
                  _buildNotesPyramid(context, perfume),
                  SizedBox(height: 24),

                  // Info details list (gender, category, seasons, use cases)
                  const SectionHeader(title: 'Kullanım Bilgileri'),
                  _buildInfoDetailRow('Kategori', perfume.category.toUpperCase()),
                  _buildInfoDetailRow('Cinsiyet Algısı', perfume.genderPerception == 'male' ? 'Erkek' : perfume.genderPerception == 'female' ? 'Kadın' : 'Uniseks'),
                  _buildInfoDetailRow('Mevsimler', perfume.season.join(', ')),
                  _buildInfoDetailRow('Kullanım Alanları', perfume.useCases.join(', ')),
                  _buildInfoDetailRow('Yaş Profili', perfume.ageProfile),
                  SizedBox(height: 28),

                  // Affiliate Shop Links
                  const SectionHeader(title: 'Satın Al / Mağazalar'),
                  
                  // Physical Store Google Maps search
                  PremiumButton(
                    text: 'YAKINDAKİ FİZİKSEL MAĞAZALARI BUL (HARİTA)',
                    icon: Icons.map_outlined,
                    onPressed: () {
                      final query = Uri.encodeComponent('${perfume.brand} ${perfume.name} Sephora Boyner Douglas parfümeri');
                      _launchUrl(context, 'https://www.google.com/maps/search/?api=1&query=$query');
                    },
                  ),
                  SizedBox(height: 16),
                  
                  if (perfume.affiliateLinks.isEmpty)
                    Text(
                      'Bu parfüm için güncel satın alma linki bulunmuyor.',
                      style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 14),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.8,
                      ),
                      itemCount: perfume.affiliateLinks.length,
                      itemBuilder: (context, index) {
                        final storeName = perfume.affiliateLinks.keys.elementAt(index);
                        final url = perfume.affiliateLinks[storeName]!;
                        return OutlinedButton(
                          onPressed: () => _launchUrl(context, url),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.accentGold.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 16, color: AppTheme.accentGold),
                              SizedBox(width: 8),
                              Text(
                                storeName,
                                style: GoogleFonts.outfit(
                                  color: isDark ? AppTheme.accentGold : AppTheme.primaryBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  SizedBox(height: 20),
                  // Affiliate disclosure
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.secondaryBlack : AppTheme.bgCream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '💡 Bazı bağlantılar affiliate link olabilir. Bu öneri güvenilirlik ilkesine göre yapılır.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricSlider(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('$value/5', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: List.generate(5, (index) {
              final active = index < value;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: active ? AppTheme.accentGold : AppTheme.borderGray.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(String title, String content) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(title, style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted)),
              SizedBox(height: 4),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesPyramid(BuildContext context, PerfumeModel perfume) {
    return Column(
      children: [
        _buildNoteRow(context, 'Üst Notalar (Açılış)', perfume.topNotes, Colors.amber[100]!),
        SizedBox(height: 8),
        _buildNoteRow(context, 'Orta Notalar (Kalp)', perfume.middleNotes, Colors.amber[200]!),
        SizedBox(height: 8),
        _buildNoteRow(context, 'Alt Notalar (Kapanış)', perfume.baseNotes, Colors.amber[300]!),
      ],
    );
  }

  Widget _buildNoteRow(BuildContext context, String type, List<String> notes, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.secondaryBlack : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? AppTheme.accentGold.withOpacity(0.3) : AppTheme.borderGray,
            ),
          ),
          child: Text(
            type,
            style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.accentGold),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            children: notes.map((note) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark 
                      ? Colors.white.withOpacity(0.05) 
                      : AppTheme.primaryBlack.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.borderGray, width: 0.5),
                ),
                child: Text(note, style: GoogleFonts.outfit(fontSize: 12)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13)),
          Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
