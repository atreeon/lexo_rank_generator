import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group('LexoRank shouldRebalanced', () {
    test('should return true when ranks need to re-balanced', () {
      final lexo = const LexoRank();
      String secondRank = 'c';
      final items = <String>[];
      for (int i = 0; i < 100; i++) {
        final rank = lexo.getRankBetween(firstRank: 'a', secondRank: secondRank);
        secondRank = rank;
        items.add(rank);
      }
      final stats = lexo.shouldRebalanced(items, maxRankLength: 5);
      expect(stats.exceeded, isTrue);
    });

    test('should return false when ranks does not need to be re-balanced', () {
      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(sizeOfItems: 100, startRankLetter: 'd', endRankLetter: 'f');
      final stats = lexo.shouldRebalanced(items, maxRankLength: 5);
      expect(stats.exceeded, isFalse);
    });

    test("add many and check the rebalance output", () {
      final lexo = const LexoRank();
      String secondRank = 'c';
      final items = <String>[];
      for (int i = 0; i < 100; i++) {
        final rank = lexo.getRankBetween(firstRank: 'a', secondRank: secondRank);
        secondRank = rank;
        items.add(rank);
      }

      //note the very large maxRankLength - shouldn't be hit
      final stats = lexo.shouldRebalanced(items, maxRankLength: 20);

      expect(stats.exceeded, isFalse);
    });

    test("0 ", () {
      final lexo = const LexoRank();

      var items = ['a', 'b', 'c', 'd', 'e'];

      var stats = lexo.shouldRebalanced(items, maxRankLength: 5);

      expect(stats.exceeded, isFalse);
    });

    test("1 ", () {
      final lexo = const LexoRank();

      var items = ['aaaaaaaa', 'aaaaaaab', 'aaaaaaac', 'd', 'e'];

      var stats = lexo.shouldRebalanced(items, maxRankLength: 5);

      expect(stats.exceeded, isTrue);
    });
  });
}
