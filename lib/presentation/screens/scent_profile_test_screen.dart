import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../widgets/reusable_widgets.dart';

class ScentProfileTestScreen extends ConsumerStatefulWidget {
  const ScentProfileTestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScentProfileTestScreen> createState() => _ScentProfileTestScreenState();
}

class _ScentProfileTestScreenState extends ConsumerState<ScentProfileTestScreen> {
  int _currentStep = 0;
  final int _totalSteps = 6;
  bool _isLoading = false;

  final List<String> _moodOptions = [
    'fresh', 'sweet', 'woody', 'spicy', 'vanilla', 'oud', 'powdery', 'floral', 'citrus', 'amber'
  ];

  final Map<String, String> _moodTranslations = {
    'fresh': '🌊 Temiz / Ferah',
    'sweet': '🍭 Tatlı / Şekerli',
    'woody': '🪵 Odunsu / Kuru',
    'spicy': '🌶️ Baharatlı / Oryantal',
    'vanilla': '🍦 Vanilyalı / Gurme',
    'oud': '🕌 Ud (Oud) / Reçinemsi',
    'powdery': '🧼 Pudralı / Sabunsu',
    'floral': '🌹 Çiçeksi / Romantik',
    'citrus': '🍋 Narenciye / Limonsu',
    'amber': '🔥 Amber / Sıcak',
  };

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _calculateResults();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.pop();
    }
  }

  Future<void> _calculateResults() async {
    setState(() {
      _isLoading = true;
    });

    final testData = ref.read(scentTestResponseProvider);
    final aiService = ref.read(aiRecommendationServiceProvider);
    
    try {
      final result = await aiService.getAiRecommendation(testData);
      ref.read(scentTestResultProvider.notifier).setResults(result);
      if (mounted) {
        context.go('/result');
      }
    } catch (e) {
      // Error fallback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata oluştu: $e. Tekrar deneyin.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.accentGold),
              const SizedBox(height: 30),
              Text(
                'ScentIQ AI Analiz Ediyor...',
                style: GoogleFonts.outfit(
                  color: AppTheme.accentGold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Kimyan, tarzın ve bütçen en uygun koku molekülleriyle eşleştiriliyor. Lütfen bekleyin.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final testState = ref.watch(scentTestResponseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('KOKU PROFİL TESTİ (${_currentStep + 1}/$_totalSteps)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: AppTheme.borderGray.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentGold),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: _buildStepContent(testState),
              ),
            ),
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: AppTheme.accentGold,
                          side: BorderSide(color: AppTheme.accentGold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'GERİ',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PremiumButton(
                      text: _currentStep == _totalSteps - 1 ? 'PROFİLİMİ ÇIKAR' : 'İLERLE',
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(Map<String, dynamic> state) {
    switch (_currentStep) {
      case 0:
        return _buildStep1(state);
      case 1:
        return _buildStep2(state);
      case 2:
        return _buildStep3(state);
      case 3:
        return _buildStep4(state);
      case 4:
        return _buildStep5(state);
      case 5:
        return _buildStep6(state);
      default:
        return const SizedBox();
    }
  }

  // Step 1: Gender & Age
  Widget _buildStep1(Map<String, dynamic> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Koku algınızı ve yaş grubunuzu seçin.'),
        const SizedBox(height: 24),
        Text('Koku Tercihi (Cinsiyet Algısı):', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildRadioTile('Erkek Kokuları', 'male', state['gender'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('gender', val);
        }),
        _buildRadioTile('Kadın Kokuları', 'female', state['gender'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('gender', val);
        }),
        _buildRadioTile('Uniseks Kokular (Herkes İçin)', 'unisex', state['gender'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('gender', val);
        }),
        _buildRadioTile('Fark Etmez / Belirtmek İstemiyorum', 'preferNotToSay', state['gender'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('gender', val);
        }),
        const SizedBox(height: 24),
        Text('Yaş Aralığınız:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Genç', '25+', '35+', 'Olgun'].map((ageOption) {
            final isSelected = state['age'] == ageOption;
            return ChoiceChip(
              label: Text(ageOption),
              selected: isSelected,
              selectedColor: AppTheme.accentGold,
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
              labelStyle: GoogleFonts.outfit(
                color: isSelected ? AppTheme.primaryBlack : (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                fontWeight: FontWeight.bold,
              ),
              onSelected: (selected) {
                if (selected) {
                  ref.read(scentTestResponseProvider.notifier).updateField('age', ageOption);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 2: Budget & Category
  Widget _buildStep2(Map<String, dynamic> state) {
    final isNicheSelected = state['designerOrNiche'] == 'niche';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Bütçe limitleriniz ve parfüm kategorisi tercihiniz.'),
        const SizedBox(height: 24),
        Text('Bütçe Seviyeniz (Koku Şişesi Başına):', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildRadioTile('Bütçe Dostu (₺)', '₺', state['budget'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('budget', val);
        }, enabled: !isNicheSelected),
        _buildRadioTile('Ortalama / Designer Fiyatı (₺₺)', '₺₺', state['budget'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('budget', val);
        }, enabled: !isNicheSelected),
        _buildRadioTile('Yüksek / Premium Niş (₺₺₺)', '₺₺₺', state['budget'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('budget', val);
        }),
        _buildRadioTile('Çok Özel Koleksiyonlar (₺₺₺₺)', '₺₺₺₺', state['budget'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('budget', val);
        }),
        const SizedBox(height: 24),
        Text('Parfüm Sınıfı Tercihiniz:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildRadioTile('Designer Parfümleri (Herkesin Bildiği Markalar)', 'designer', state['designerOrNiche'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('designerOrNiche', val);
        }),
        _buildRadioTile('Niş Parfümler (Özgün ve Nadide Sanat Eserleri)', 'niche', state['designerOrNiche'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('designerOrNiche', val);
          // If niche is chosen and budget is currently low/medium, auto-promote to premium niche
          final currentBudget = state['budget'];
          if (currentBudget == '₺' || currentBudget == '₺₺') {
            ref.read(scentTestResponseProvider.notifier).updateField('budget', '₺₺₺');
          }
        }),
      ],
    );
  }

  // Step 3: Use Case & Scent Mood
  Widget _buildStep3(Map<String, dynamic> state) {
    final selectedMoods = List<String>.from(state['moods']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Parfümü nerede kullanacaksınız ve hangi ruh halini yansıtmalı?'),
        const SizedBox(height: 24),
        Text('Ana Kullanım Senaryosu:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: state['useCase'] == 'Daily' ? 'Günlük' : state['useCase'],
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
          ),
          items: ['Günlük', 'Ofis', 'Date', 'Gece/Kulüp', 'Spor', 'Özel Davet', 'Hediye'].map((uc) {
            return DropdownMenuItem<String>(value: uc, child: Text(uc));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(scentTestResponseProvider.notifier).updateField('useCase', val);
            }
          },
        ),
        const SizedBox(height: 24),
        Text('Beğendiğiniz Koku Karakterleri (Birden Fazla Seçilebilir):', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text('Tarzınızı yansıtan, koklamaktan keyif aldığınız her şeyi seçin.', style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _moodOptions.map((mood) {
            final isSelected = selectedMoods.contains(mood);
            return ScentKeycapChip(
              text: _moodTranslations[mood]!,
              isSelected: isSelected,
              onTap: () => ref.read(scentTestResponseProvider.notifier).toggleMood(mood),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 4: Disliked Moods
  Widget _buildStep4(Map<String, dynamic> state) {
    final dislikedMoods = List<String>.from(state['dislikedMoods']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Asla tahammül edemediğiniz koku türleri hangileri?'),
        const SizedBox(height: 8),
        Text('Bu koku tiplerini içeren parfümler önerilerden elenecektir.', style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _moodOptions.map((mood) {
            final isSelected = dislikedMoods.contains(mood);
            return ScentKeycapChip(
              text: _moodTranslations[mood]!,
              isSelected: isSelected,
              onTap: () => ref.read(scentTestResponseProvider.notifier).toggleDislikedMood(mood),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 5: Performance expectation
  Widget _buildStep5(Map<String, dynamic> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Parfümden performans beklentileriniz nedir?'),
        const SizedBox(height: 24),
        Text('Yoğunluk (Konsantrasyon) Tercihi:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        _buildRadioTile('Hafif / Tazeleyici (Ferah ve uçucu)', 'soft', state['intensity'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('intensity', val);
        }),
        _buildRadioTile('Dengeli (Günlük kullanıma ve ofise uygun)', 'balanced', state['intensity'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('intensity', val);
        }),
        _buildRadioTile('Güçlü (Kendini hissettiren, yoğun koku izi)', 'strong', state['intensity'], (val) {
          ref.read(scentTestResponseProvider.notifier).updateField('intensity', val);
        }),
        const SizedBox(height: 24),
        Text('Kalıcılık Beklentisi:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: state['longevity'],
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
          ),
          items: ['Zayıf', 'Orta', 'Kalıcı', 'Çok Kalıcı'].map((l) {
            return DropdownMenuItem<String>(value: l, child: Text(l));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(scentTestResponseProvider.notifier).updateField('longevity', val);
            }
          },
        ),
        const SizedBox(height: 24),
        Text('Yayılım (Fark Edilebilirlik) Beklentisi:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: state['projection'],
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
          ),
          items: ['Zayıf', 'Orta', 'Güçlü', 'Canavar'].map((p) {
            return DropdownMenuItem<String>(value: p, child: Text(p));
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(scentTestResponseProvider.notifier).updateField('projection', val);
            }
          },
        ),
      ],
    );
  }

  // Step 6: Already liked/disliked reference perfumes
  Widget _buildStep6(Map<String, dynamic> state) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final allPerfumes = repo.getAll();

    final likedList = List<String>.from(state['likedPerfumes']);
    final dislikedList = List<String>.from(state['dislikedPerfumes']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader('Daha önce kullandığınız ve beğendiğiniz / beğenmediğiniz parfümler hangileri?'),
        const SizedBox(height: 8),
        Text('Bu veriler yapay zekanın tarzınızı anlamasını kolaylaştıracaktır.', style: GoogleFonts.outfit(color: AppTheme.textMuted, fontSize: 12)),
        const SizedBox(height: 24),
        Text('Sevdiğiniz Parfümler:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allPerfumes.map((perfume) {
            final isLiked = likedList.contains(perfume.id);
            return FilterChip(
              label: Text('${perfume.brand} ${perfume.name}'),
              selected: isLiked,
              selectedColor: AppTheme.accentGold,
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
              onSelected: (selected) {
                final current = List<String>.from(likedList);
                if (selected) {
                  current.add(perfume.id);
                  // Remove from dislike if it was there
                  ref.read(scentTestResponseProvider.notifier).updateField(
                    'dislikedPerfumes',
                    List<String>.from(dislikedList)..remove(perfume.id),
                  );
                } else {
                  current.remove(perfume.id);
                }
                ref.read(scentTestResponseProvider.notifier).updateField('likedPerfumes', current);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('Beğenmediğiniz Parfümler:', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allPerfumes.map((perfume) {
            final isDisliked = dislikedList.contains(perfume.id);
            return FilterChip(
              label: Text('${perfume.brand} ${perfume.name}'),
              selected: isDisliked,
              selectedColor: Colors.redAccent.withOpacity(0.8),
              backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppTheme.secondaryBlack : Colors.white,
              onSelected: (selected) {
                final current = List<String>.from(dislikedList);
                if (selected) {
                  current.add(perfume.id);
                  // Remove from liked if it was there
                  ref.read(scentTestResponseProvider.notifier).updateField(
                    'likedPerfumes',
                    List<String>.from(likedList)..remove(perfume.id),
                  );
                } else {
                  current.remove(perfume.id);
                }
                ref.read(scentTestResponseProvider.notifier).updateField('dislikedPerfumes', current);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionHeader(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 20,
            height: 1.3,
            fontFamily: GoogleFonts.outfit().fontFamily,
          ),
    );
  }

  Widget _buildRadioTile(
    String title,
    String value,
    String currentValue,
    ValueChanged<String> onChanged, {
    bool enabled = true,
  }) {
    final isSelected = value == currentValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: !enabled
            ? (isDark ? Colors.grey.withOpacity(0.05) : Colors.grey.withOpacity(0.08))
            : (isSelected
                ? AppTheme.accentGold.withOpacity(0.08)
                : (isDark ? AppTheme.secondaryBlack : Colors.white)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: !enabled
              ? (isDark ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.2))
              : (isSelected ? AppTheme.accentGold : (isDark ? AppTheme.darkBrown : AppTheme.borderGray)),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: !enabled
                ? (isDark ? Colors.grey[600] : Colors.grey[400])
                : (isSelected ? AppTheme.accentGold : (isDark ? Colors.white : Colors.black)),
          ),
        ),
        value: value,
        groupValue: currentValue,
        activeColor: AppTheme.accentGold,
        onChanged: enabled
            ? (val) {
                if (val != null) onChanged(val);
              }
            : null,
      ),
    );
  }
}
