import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class DailySuggestionScreen extends ConsumerStatefulWidget {
  const DailySuggestionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DailySuggestionScreen> createState() => _DailySuggestionScreenState();
}

class _DailySuggestionScreenState extends ConsumerState<DailySuggestionScreen> {
  double _temperature = 20.0;
  String _season = 'İlkbahar';
  String _plan = 'casual'; // 'office' | 'date' | 'casual' | 'special'
  String _mood = 'fresh'; // 'fresh' | 'sweet' | 'bold' | 'elegant'

  bool _showResult = false;
  PerfumeModel? _suggestion;
  String _warningText = '';

  final Map<String, String> _planTranslations = {
    'casual': 'Günlük / Sıradan',
    'office': 'Ofis / İş Toplantısı',
    'date': 'Buluşma / Date',
    'special': 'Özel Davet / Gece',
  };

  final Map<String, String> _moodTranslations = {
    'fresh': 'Temiz ve Ferah',
    'sweet': 'Tatlı ve Sıcak',
    'bold': 'Baharatlı ve Maskülen',
    'elegant': 'Elit ve Pudralı',
  };

  void _calculateDailySuggestion() {
    final repo = ref.read(perfumeRepositoryProvider);
    
    // Resolve suggestion
    final result = repo.getDailySuggestion(
      temperature: _temperature.toInt(),
      season: _season,
      plan: _plan,
      mood: _mood,
    );

    // Formulate custom warning text based on temperature and selected mood/scent profile
    String warning = '';
    if (_temperature > 25) {
      if (result.sweetnessLevel >= 4 || result.spicyLevel >= 4) {
        warning = '⚠️ Bugün hava çok sıcak (${_temperature.toInt()}°C). Seçilen koku biraz yoğun/şekerli kalabilir. Eğer sıkacaksanız fıs sayısını 2 ile sınırlı tutun!';
      } else {
        warning = '✨ Harika seçim! Sıcak hava için ferah ve canlandırıcı bir koku. Gün boyu temizlik hissi verecektir.';
      }
    } else if (_temperature < 15) {
      if (result.freshnessLevel >= 4 && result.sweetnessLevel <= 2) {
        warning = '❄️ Hava oldukça soğuk (${_temperature.toInt()}°C). Ferah kokular soğuk havada çabuk söner. Daha tatlı/baharatlı ve kalıcı bir kış kokusu tercih edebilirsiniz.';
      } else {
        warning = '🔥 Soğuk hava için mükemmel, tatlılığı ve kalıcılığı yerinde koruyucu bir koku seçildi.';
      }
    } else {
      warning = '🌿 Ilıman hava şartları için son derece dengeli ve güvenli bir imza koku profili.';
    }

    setState(() {
      _suggestion = result;
      _warningText = warning;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double ratio = ((_temperature - 5.0) / (40.0 - 5.0)).clamp(0.0, 1.0);
    final Color darkAccent = Color.lerp(Colors.black, AppTheme.accentGold, 0.45)!;
    final Color lightAccent = Color.lerp(Colors.white, AppTheme.accentGold, 0.7)!;
    final Color sliderColor = Color.lerp(darkAccent, lightAccent, ratio)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BUGÜN NE SIKILIR?'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Günün Kokusunu Belirle',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 22,
                    ),
              ),
              SizedBox(height: 6),
              Text(
                'Hava sıcaklığını ve bugünkü planını gir, günün koşullarına en uygun koku tavsiyesini al.',
                style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 24),

              // Inputs Card
              Card(
                color: isDark ? AppTheme.secondaryBlack : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Temperature Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dışarıdaki Sıcaklık:',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '${_temperature.toInt()}°C',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: sliderColor,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 6,
                          trackShape: GradientSliderTrackShape(
                            startColor: darkAccent,
                            endColor: lightAccent,
                          ),
                          activeTrackColor: sliderColor,
                          inactiveTrackColor: AppTheme.borderGray.withOpacity(0.3),
                          thumbColor: sliderColor,
                          overlayColor: sliderColor.withOpacity(0.2),
                          valueIndicatorColor: sliderColor,
                        ),
                        child: Slider(
                          value: _temperature,
                          min: 5.0,
                          max: 40.0,
                          divisions: 35,
                          onChanged: (val) {
                            setState(() {
                              _temperature = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.ac_unit, size: 26, color: AppTheme.accentGold),
                            Icon(Icons.wb_sunny, size: 26, color: AppTheme.accentGold),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Season
                      Text(
                        'Şu Anki Mevsim:',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _season,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: ['İlkbahar', 'Yaz', 'Sonbahar', 'Kış'].map((s) {
                          return DropdownMenuItem<String>(value: s, child: Text(s));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _season = val);
                        },
                      ),
                      SizedBox(height: 16),

                      // Plan
                      Text(
                        'Bugünkü Planınız:',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _plan,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: _planTranslations.keys.map((k) {
                          return DropdownMenuItem<String>(value: k, child: Text(_planTranslations[k]!));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _plan = val);
                        },
                      ),
                      SizedBox(height: 16),

                      // Mood
                      Text(
                        'İstediğiniz Hissiyat (Mod):',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _mood,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: _moodTranslations.keys.map((k) {
                          return DropdownMenuItem<String>(value: k, child: Text(_moodTranslations[k]!));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _mood = val);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              PremiumButton(
                text: 'KOKUMU BELİRLE',
                icon: Icons.wb_cloudy_outlined,
                onPressed: _calculateDailySuggestion,
              ),
              SizedBox(height: 28),

              // Results View
              if (_showResult && _suggestion != null) ...[
                Text(
                  'Günün Parfüm Önerisi',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentGold, letterSpacing: 1),
                ),
                SizedBox(height: 12),
                
                // Warning Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _warningText.contains('⚠️')
                        ? AppTheme.statusDanger.withOpacity(0.08)
                        : AppTheme.accentGold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _warningText.contains('⚠️')
                          ? AppTheme.statusDanger.withOpacity(0.3)
                          : AppTheme.accentGold.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _warningText,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _warningText.contains('⚠️') ? Colors.redAccent : AppTheme.accentGold,
                      height: 1.4,
                    ),
                  ),
                ),
                PerfumeCard(perfume: _suggestion!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GradientSliderTrackShape extends RoundedRectSliderTrackShape {
  final Color startColor;
  final Color endColor;

  const GradientSliderTrackShape({
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2.0,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackRadius = Radius.circular(sliderTheme.trackHeight! / 2);

    final activePaint = Paint()
      ..shader = LinearGradient(
        colors: [startColor, endColor],
      ).createShader(trackRect);

    final Rect activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, trackRadius),
      activePaint,
    );

    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? Colors.grey.withOpacity(0.2);

    final Rect inactiveRect = Rect.fromLTRB(
      thumbCenter.dx,
      trackRect.top,
      trackRect.right,
      trackRect.bottom,
    );

    context.canvas.drawRRect(
      RRect.fromRectAndRadius(inactiveRect, trackRadius),
      inactivePaint,
    );
  }
}
