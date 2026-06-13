import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/app_providers.dart';
import '../../data/models/perfume_model.dart';
import '../widgets/reusable_widgets.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(perfumeRepositoryProvider);
    final favIds = ref.watch(favoritesProvider);

    // Resolve model instances
    final favPerfumes = favIds.map((id) => repo.getById(id)).whereType<PerfumeModel>().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAVORİ PARFÜMLERİM'),
      ),
      body: favPerfumes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 60,
                      color: AppTheme.accentGold.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Favori Listeniz Boş',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Beğendiğiniz parfümleri kalp simgesine basarak kaydedebilir ve burada görüntüleyebilirsiniz.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 24),
                    PremiumButton(
                      text: 'KOKULARI KEŞFET',
                      isFullWidth: false,
                      onPressed: () => context.go('/home'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: favPerfumes.length,
              itemBuilder: (context, index) {
                final perfume = favPerfumes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: PerfumeCard(
                    perfume: perfume,
                    isFavorite: true,
                    onFavoriteTap: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(perfume.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${perfume.name} favorilerden kaldırıldı.'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: PremiumBottomNavigationBar(
        currentIndex: 1,
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
}
