import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';
import 'package:test/test.dart';

void main() {
  group("genInitialRank2", () {
    test('bug 1', () {
      //pass two rank values
      final items = getRankBetweenMulti(
        sizeOfItems: 3,
        startRankLetter: /**/ 'aaaaaaaaannn',
        endRankLetter: /*  */ 'aaaaaaaabbbb',
      );

      //the result should be the start & end
      // and one new in the middle of them both
      var expected = [
        'aaaaaaaaannn',
        'aaaaaaaaauhh',
        'aaaaaaaabbbb',
      ];

      expect(items, expected);
    });

    test('check the new one is in the middle', () {
      final items = getRankBetweenMulti(
        sizeOfItems: 3,
        startRankLetter: 'aab',
        endRankLetter: 'acc',
      );

      expect(items[0], 'aab');
      expect(items[1], 'abb');
      expect(items[2], 'acc');
    });

    test('should generate all letters between a to z (26)', () {
      final items = <String>[];
      for (int i = 97; i < 123; i++) {
        final c = String.fromCharCode(i);
        items.add(c);
      }

      var result1 = getRankBetweenMulti(sizeOfItems: 26, startRankLetter: 'a', endRankLetter: 'z');
      expect(result1, containsAll(items));
    });

    test('create 5 in the middle', () {
      final items = getRankBetweenMulti(
        sizeOfItems: 7,
        startRankLetter: 'aab',
        endRankLetter: 'acc',
      );

      var expected = ['aab', 'aao', 'aau', 'abb', 'abo', 'abv', 'acc'];

      expect(items, expected);
    });

    test('big with moveMultiInList', () {
      final items = getRankBetweenMulti(
        sizeOfItems: 4,
        startRankLetter: 'bekxxxxxxxxx',
        endRankLetter: 'bhuuuuuuuuuu',
      );

      var expected = ['bekxxxxxxxxx', 'bgcwjjjjjjji', 'bgyvpccccccb', 'bhuuuuuuuuuu'];

      expect(items, expected);
    });

    test('big with moveMultiInList', () {
      final items = getRankBetweenMulti(
        sizeOfItems: 4,
        startRankLetter: 'aaa',
        endRankLetter: 'ddd',
      );

      var expected = ['aaa', 'boo', 'civ', 'ddd'];

      expect(items, expected);
    });

    test('endRankLetter all aaaa, cannot move above it', () {
      //this should never happen
      try {
        getRankBetweenMulti(
          sizeOfItems: 4,
          startRankLetter: 'aaa',
          endRankLetter: 'aaaa',
        );
      } on LexoRankException {
        expect(true, true);
        return;
      }

      throw Exception('should throw an LexoRankException');
    });
  });
}
