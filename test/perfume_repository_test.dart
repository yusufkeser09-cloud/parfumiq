import 'package:flutter_test/flutter_test.dart';
import '../lib/data/repositories/perfume_repository.dart';
import '../lib/data/models/perfume_model.dart';

void main() {
  group('PerfumeRepository Tests', () {
    late PerfumeRepository repository;

    setUp(() {
      repository = PerfumeRepository();
    });

    test('Should load all seed perfumes (exactly 97)', () {
      final perfumes = repository.getAll();
      expect(perfumes.length, equals(97));
    });

    test('Should find perfume by ID', () {
      final perfume = repository.getById('creed_aventus');
      expect(perfume, isNotNull);
      expect(perfume!.name, equals('Aventus'));
      expect(perfume.brand, equals('Creed'));
    });

    test('Should return null for non-existing ID', () {
      final perfume = repository.getById('invalid_id');
      expect(perfume, isNull);
    });

    test('Should search perfumes by name or brand case-insensitively', () {
      final results = repository.search('dior');
      expect(results.length, greaterThan(0));
      expect(results.every((p) => p.brand.toLowerCase().contains('dior') || p.name.toLowerCase().contains('dior')), isTrue);
    });

    test('Should analyze empty wardrobe and advise to take a test', () {
      final analysis = repository.analyzeWardrobe([]);
      expect(analysis, contains('boş'));
    });

    test('Should analyze wardrobe with sweet perfumes and advise fresh additions', () {
      final tobaccoVanille = repository.getById('tobacco_vanille')!;
      final baccarat = repository.getById('baccarat_rouge')!;
      final khamrah = repository.getById('lattafa_khamrah')!;
      
      final owned = [tobaccoVanille, baccarat, khamrah];
      final analysis = repository.analyzeWardrobe(owned);
      
      expect(analysis, contains('ferah'));
    });
  });
}
