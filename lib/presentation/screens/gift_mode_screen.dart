import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class GiftModeScreen extends ConsumerStatefulWidget {
  const GiftModeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GiftModeScreen> createState() => _GiftModeScreenState();
}

class _GiftModeScreenState extends ConsumerState<GiftModeScreen> {
  // Survey responses
  String _gender = 'unisex';
  String _age = '25+';
  String _style = 'Modern';
  String _budget = '₺₺';
  String _safeOrImpressive = 'safe';

  bool _showResults = false;
  List<PerfumeModel> _recommendations = [];

  final List<String> _styles = ['Classic', 'Modern', 'Clean', 'Luxury', 'Sweet', 'Bold', 'Minimal'];

  void _generateGiftRecommendations() {
    final repo = ref.read(perfumeRepositoryProvider);
    final results = repo.getGiftRecommendations(
      gender: _gender,
      style: _style,
      budget: _budget,
      safeOrImpressive: _safeOrImpressive,
    );

    setState(() {
      _recommendations = results;
      _showResults = true;
    });
  }

  void _resetSurvey() {
    setState(() {
      _showResults = false;
      _recommendations = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favList = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HEDİYE MODU'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _showResults
              ? _buildResultsView(context, favList)
              : _buildFormView(context, isDark),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'En Doğru Hediye Parfümü Seç',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 22,
              ),
        ),
        SizedBox(height: 6),
        Text(
          'Hediye alacağınız kişinin profil bilgilerini doldurun, ona yakışacak en risksiz ve etkileyici parfümleri bulalım.',
          style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
        ),
        SizedBox(height: 24),

        // Recipients gender
        Text('Hediye Kimin İçin?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildChoiceChip('Erkek', _gender == 'male', () => setState(() => _gender = 'male')),
            SizedBox(width: 8),
            _buildChoiceChip('Kadın', _gender == 'female', () => setState(() => _gender = 'female')),
            SizedBox(width: 8),
            _buildChoiceChip('Uniseks (Ortak)', _gender == 'unisex', () => setState(() => _gender = 'unisex')),
          ],
        ),
        SizedBox(height: 20),

        // Age Profile
        Text('Yaş Aralığı:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildChoiceChip('Genç', _age == 'Genç', () => setState(() => _age = 'Genç')),
            SizedBox(width: 8),
            _buildChoiceChip('25+', _age == '25+', () => setState(() => _age = '25+')),
            SizedBox(width: 8),
            _buildChoiceChip('35+', _age == '35+', () => setState(() => _age = '35+')),
            SizedBox(width: 8),
            _buildChoiceChip('Olgun', _age == 'Olgun', () => setState(() => _age = 'Olgun')),
          ],
        ),
        SizedBox(height: 20),

        // Style
        Text('Giyim / Yaşam Tarzı:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _styles.map((st) {
            return ChoiceChip(
              label: Text(st),
              selected: _style == st,
              selectedColor: AppTheme.accentGold,
              labelStyle: GoogleFonts.outfit(
                color: _style == st ? AppTheme.primaryBlack : (isDark ? Colors.white : Colors.black),
                fontWeight: FontWeight.bold,
              ),
              onSelected: (selected) {
                if (selected) setState(() => _style = st);
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),

        // Budget
        Text('Bütçe Aralığı:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildChoiceChip('Ekonomik (₺)', _budget == '₺', () => setState(() => _budget = '₺')),
            SizedBox(width: 8),
            _buildChoiceChip('Designer (₺₺)', _budget == '₺₺', () => setState(() => _budget = '₺₺')),
            SizedBox(width: 8),
            _buildChoiceChip('Premium Niş (₺₺₺)', _budget == '₺₺₺', () => setState(() => _budget = '₺₺₺')),
          ],
        ),
        SizedBox(height: 20),

        // Risk Preference (Safe / Impressive)
        Text('Hediye Karakteri Tercihi:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        SizedBox(height: 8),
        Row(
          children: [
            _buildChoiceChip(
              'Güvenli Seçim (Risksiz, Herkes Beğenir)',
              _safeOrImpressive == 'safe',
              () => setState(() => _safeOrImpressive = 'safe'),
            ),
            SizedBox(width: 8),
            _buildChoiceChip(
              'Etkileyici / Farklı (Niş ve Karakterli)',
              _safeOrImpressive == 'impressive',
              () => setState(() => _safeOrImpressive = 'impressive'),
            ),
          ],
        ),
        SizedBox(height: 36),

        PremiumButton(
          text: 'HEDİYE PARFÜM BUL',
          icon: Icons.search,
          onPressed: _generateGiftRecommendations,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultsView(BuildContext context, List<String> favList) {
    // Split recommendations: first 3 are safe, next 2 are impressive
    final safePerfumes = _recommendations.take(3).toList();
    final impressivePerfumes = _recommendations.skip(3).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Önerilen Hediye Listesi',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 22),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: AppTheme.accentGold),
              onPressed: _resetSurvey,
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          'Seçtiğiniz profile göre en iyi 3 risksiz hediye ve 2 adet karakterli alternatif listelenmiştir.',
          style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
        ),
        SizedBox(height: 20),

        // Gifting Advice Box
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
              Text(
                '💡 Davud\'un Hediye Tüyosu:',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.accentGold),
              ),
              SizedBox(height: 8),
              Text(
                'Eğer hediye alacağınız kişinin ne tür kokuları sevdiğini hiç bilmiyorsanız, risksiz "Güvenli Seçim" olan 1. öneriye yönelin. Eğer onun daha prestijli ve imza bir tarzı varsa, "Riskli ama Karakterli" alternatifler onu daha fazla şaşırtacaktır.',
                style: GoogleFonts.outfit(fontSize: 13, color: AppTheme.bgCream.withOpacity(0.9), height: 1.5),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),

        // Safe Picks Section
        Text(
          'RİSKSİZ VE GÜVENLİ HEDİYELER (Top 3)',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold, letterSpacing: 1.5),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: safePerfumes.length,
          itemBuilder: (context, index) {
            final p = safePerfumes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: PerfumeCard(
                perfume: p,
                isFavorite: favList.contains(p.id),
                onFavoriteTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(p.id),
              ),
            );
          },
        ),
        SizedBox(height: 24),

        // Impressive Picks Section
        if (impressivePerfumes.isNotEmpty) ...[
          Text(
            'ETKİLEYİCİ VE DAHA RİSKLİ SEÇENEKLER (Top 2)',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.accentGold, letterSpacing: 1.5),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: impressivePerfumes.length,
            itemBuilder: (context, index) {
              final p = impressivePerfumes[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: PerfumeCard(
                  perfume: p,
                  isFavorite: favList.contains(p.id),
                  onFavoriteTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(p.id),
                ),
              );
            },
          ),
        ],

        SizedBox(height: 20),
        PremiumButton(
          text: 'TESTİ YENİLE',
          isSecondary: true,
          onPressed: _resetSurvey,
        ),
        SizedBox(height: 30),
      ],
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.accentGold
                : (isDark ? AppTheme.secondaryBlack : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppTheme.accentGold : (isDark ? AppTheme.darkBrown : AppTheme.borderGray),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppTheme.primaryBlack : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
