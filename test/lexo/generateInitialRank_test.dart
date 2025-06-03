import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group('LexoRank generateInitialRank', () {
    test('never have a rank with all a', () {
      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(
        sizeOfItems: 3,
        rankLength: 12,
        startRankLetter: 'b',
        endRankLetter: 'y',
      );

      var whereAllAs = items.where((x) => x.characters.every((y) => y == 'a'));

      expect(whereAllAs.firstOrNull, null);
    });

    test('the rank length should be correct', () {
      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(
        sizeOfItems: 3,
        rankLength: 12,
        startRankLetter: 'a',
        endRankLetter: 'z',
      );

      var expected = [
        'aaaaaaaaaaaa',
        'bbbbbbbbbbbb',
        'cccccccccccc',
      ];

      expect(items, expected);
    });

    test('the rank length should be 12 throughout if we can satisfy that', () {
      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(
        sizeOfItems: 100,
        rankLength: 12,
        startRankLetter: 'a',
        endRankLetter: 'z',
      );

      var anyLessThan12Chars = items.map((x) => x.length).any((x) => x < 12);
      expect(false, anyLessThan12Chars);

      var maxLength = items.map((x) => x.length).max();
      expect(maxLength, 12);
    });

    test('If we have more than [rankLength] x 26 items then we can have a rank greater in size than [rankLength] but not less than [rankLength]', () {
      final rankLength = 3;

      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(
        sizeOfItems: 5000,
        rankLength: rankLength,
        startRankLetter: 'a',
        endRankLetter: 'z',
      );

      var anyLessThan12Chars = items.map((x) => x.length).any((x) => x < rankLength);
      expect(false, anyLessThan12Chars);

      var maxLength = items.map((x) => x.length).max();
      expect(maxLength, 5);

      expect(items.toSet().length, items.length);
    });

    test('start and end ranks should be a single character', () {
      final lexo = const LexoRank();
      try {
        lexo.generateInitialRank(
          sizeOfItems: 3,
          rankLength: 5,
          startRankLetter: 'aab',
          endRankLetter: 'acc',
        );
      } on LexoRankException {
        expect(true, true);
        return;
      }

      throw Exception('should throw an LexoRankException');
    });

    test('should generate a List ordered of rank items', () {
      final lexo = const LexoRank();

      final expected = <String>[]; //[aaaaa, bbbbb, ccccc, ...]
      for (int i = 97; i < 123; i++) {
        final c = String.fromCharCode(i);
        expected.add(List.generate(5, (index) => c).join());
      }
      expect(lexo.generateInitialRank(sizeOfItems: 26), containsAll(expected));
      expect(lexo.generateInitialRank(sizeOfItems: 100), containsAll(['bviii', 'eeeee', 'akdqq']));
    });

    test('should generate a List ordered of rank items with custom rank length', () {
      final lexo = const LexoRank();
      final items = <String>[];
      for (int i = 97; i < 123; i++) {
        final c = String.fromCharCode(i);
        items.add(List.generate(3, (index) => c).join());
      }

      expect(lexo.generateInitialRank(sizeOfItems: 26, rankLength: 3), containsAll(items));
      expect(lexo.generateInitialRank(sizeOfItems: 1000, rankLength: 3), containsAll(['bts', 'btt', 'bug', 'izn']));
    });

    test('should not throw exception when base list has insufficient items', () {
      final lexo = const LexoRank();

      expect(
        lexo.generateInitialRank(
          sizeOfItems: 1,
          rankLength: 5,
          startRankLetter: 'a',
          endRankLetter: 'c',
        ),
        equals(['aaaaa']),
      );
    });
  });
}
