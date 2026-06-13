import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class DupeFinderScreen extends ConsumerStatefulWidget {
  const DupeFinderScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DupeFinderScreen> createState() => _DupeFinderScreenState();
}

class _DupeFinderScreenState extends ConsumerState<DupeFinderScreen> {
  String? _selectedPerfumeId;

  // Mock comparison texts database for alternatives
  final Map<String, Map<String, Map<String, String>>> _comparisons = {
    'creed_aventus': {
      'club_de_nuit_intense': {
        'why': 'Açılıştaki narenciye ve kurudukça ortaya çıkan dumanlı huş ağacı-ananas dengesi Aventus havasını yansıtır.',
        'better': 'Kalıcılık ve yayılımda Aventus\'un yeni serilerinden belirgin şekilde daha güçlü ve fiyatı 10 kat daha ucuz.',
        'weaker': 'İlk 15 dakikadaki limon açılışı oldukça sentetik ve keskin; Aventus\'taki o doğal, yumuşak lüks geçiş yok.',
      },
      'zara_vibrant_leather': {
        'why': 'Bergamot ve bambu notalarıyla Aventus\'un o meşhur meyveli-odunsu ferahlığını hafif ve temiz bir şekilde taklit eder.',
        'better': 'Çok hafif ve yormayan bir koku. Günlük kullanımda ve spor sonrasında Aventus\'tan daha konforlu. Fiyatı bedava gibi.',
        'weaker': 'Kalıcılık ve fark edilirlik çok zayıf. Dumanlılık ve derinlik barındırmaz, 2-3 saatte uçar gider.',
      },
      'montblanc_explorer': {
        'why': 'Yüksek kaliteli bergamot, paçuli ve ambroxan kombinasyonu ile Aventus\'un meyveli-odunsu DNA\'sını modernleştirerek sunar.',
        'better': 'Sentetiklik hissiyatı çok düşüktür. Kaliteli şişesi ve dengeli yapısıyla tam bir fiyat/performans designer imza kokusu.',
        'weaker': 'Aventus kadar dumanlı ve gizemli değil. Meyve tatlılığı biraz daha tek düze kalıyor.',
      }
    },
    'tobacco_vanille': {
      'lattafa_khamrah': {
        'why': 'Sıcak baharatlar, pralin ve yoğun vanilya tatlılığı ile Tobacco Vanille\'in o ağır kışlık gurme havasını destekler.',
        'better': 'Fiyatı inanılmaz uygun. Şişesi ve sunumu lüks segmentte. İçindeki hurma tatlılığı parfümü daha lezzetli kılıyor.',
        'weaker': 'Tütün yaprağı notası barındırmaz, daha çok elmalı tarçınlı kek gibi kokar. Kapalı alanda fazla bayebilir.',
      },
      'by_the_fireplace': {
        'why': 'Yoğun odunsu dumanlılık ve kestane eşliğinde gelen vanilya tatlılığı ile benzer sıcak gurme havasını taşır.',
        'better': 'Çok daha özgün ve sanatsal bir koku profili sunar. Gerçek şömine dumanı hissi Tobacco Vanille\'den daha karakterlidir.',
        'weaker': 'Tütün içermez. Dumanlı açılışı kestaneden ötürü herkesin sevebileceği türden değildir, risklidir.',
      }
    },
    'angels_share': {
      'lattafa_khamrah': {
        'why': 'Pralin, tarçın ve yoğun vanilya birleşimiyle Angels\' Share\'in o meşhur elmalı turta tatlıliğini andırır.',
        'better': 'Performansı ve kalıcılığı canavar gibidir. Angels\' Share fiyatının onda birine satılır.',
        'weaker': 'Angels\' Share\'deki o lüks ve asil konyak/likör hissiyatı Khamrah\'ta yoktur, daha düz tatlıdır.',
      }
    },
    'dior_sauvage_edt': {
      'dior_sauvage_elixir': {
        'why': 'Sauvage DNA\'sını taşır ancak çok daha konsantre, baharatlı ve karanlık bir yapıya büründürülmüştür.',
        'better': 'Kalıcılık ve fark edilirlik kelimenin tam anlamıyla canavardır. Son derece karizmatik ve maskülendir.',
        'weaker': 'Fiyatı klasik Sauvage\'a göre çok daha yüksektir. Ferah bir yaz kokusu olmaktan çıkmış, ağır bir kış kokusu olmuştur.',
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final favList = ref.watch(favoritesProvider);

    // Filter only perfumes that have comparative alternatives in our system
    final basePerfumes = repo.getAll().where((p) =>
        p.id == 'creed_aventus' ||
        p.id == 'tobacco_vanille' ||
        p.id == 'angels_share' ||
        p.id == 'dior_sauvage_edt').toList();

    final alternatives = _selectedPerfumeId != null
        ? repo.getAlternativeFinderResults(_selectedPerfumeId!)
        : <PerfumeModel>[];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALTERNATİF BUL'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Benzer Koku Profillerini Keşfet',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 22,
                    ),
              ),
              SizedBox(height: 6),
              Text(
                'Beğendiğin pahalı veya popüler bir parfümü seç, benzer koku DNA\'sına sahip alternatifleri inceleyelim.',
                style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 20),

              // Dropdown Selection
              Text(
                'Beğendiğiniz Parfüm:',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPerfumeId,
                hint: const Text('Bir parfüm seçin...'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: isDark ? AppTheme.secondaryBlack : Colors.white,
                ),
                items: basePerfumes.map((p) {
                  return DropdownMenuItem<String>(
                    value: p.id,
                    child: Text('${p.brand} - ${p.name}'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedPerfumeId = val;
                  });
                },
              ),
              SizedBox(height: 24),

              if (_selectedPerfumeId == null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        Icon(Icons.find_in_page_outlined, size: 48, color: AppTheme.accentGold.withOpacity(0.5)),
                        SizedBox(height: 16),
                        Text(
                          'Başlamak için yukarıdan bir parfüm seçin.',
                          style: GoogleFonts.outfit(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Text(
                  'Benzer Koku Profiline Sahip Alternatifler',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 12),
                
                // Results List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alternatives.length,
                  itemBuilder: (context, index) {
                    final altPerfume = alternatives[index];
                    final isFav = favList.contains(altPerfume.id);

                    // Retrieve comparisons
                    final baseComps = _comparisons[_selectedPerfumeId];
                    final comp = baseComps != null ? baseComps[altPerfume.id] : null;

                    final whyText = comp?['why'] ?? 'Benzer koku aromalarına ve esintisine sahiptir.';
                    final betterText = comp?['better'] ?? 'Bütçe olarak çok daha uygundur.';
                    final weakerText = comp?['weaker'] ?? 'Orijinal parfümün kalitesindeki ham maddelere sahip değildir.';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header matching standard PerfumeCard but simplified
                            PerfumeCard(
                              perfume: altPerfume,
                              isFavorite: isFav,
                              onFavoriteTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(altPerfume.id),
                            ),
                            
                            // Comparison Breakdown
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.primaryBlack : AppTheme.bgCream,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.borderGray.withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'KARŞILAŞTIRMALI SCENTIQ DEĞERLENDİRMESİ',
                                      style: GoogleFonts.outfit(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.accentGold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    _buildComparisonRow(
                                      context,
                                      icon: Icons.info_outline,
                                      iconColor: Colors.blue,
                                      title: 'Neden Benzer?',
                                      text: whyText,
                                    ),
                                    SizedBox(height: 8),
                                    _buildComparisonRow(
                                      context,
                                      icon: Icons.add_circle_outline,
                                      iconColor: AppTheme.statusSuccess,
                                      title: 'Nerede Daha İyi?',
                                      text: betterText,
                                    ),
                                    SizedBox(height: 8),
                                    _buildComparisonRow(
                                      context,
                                      icon: Icons.remove_circle_outline,
                                      iconColor: AppTheme.statusDanger,
                                      title: 'Nerede Daha Zayıf?',
                                      text: weakerText,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                height: 1.4,
              ),
              children: [
                TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
