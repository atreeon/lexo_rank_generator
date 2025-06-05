import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group('LexoRank getRankBetween', () {
    test('should rank correctly between two rank', () {
      final lexo = const LexoRank();
      expect(lexo.getRankBetween(firstRank: 'a', secondRank: 'c'), equals('b'));
      expect(lexo.getRankBetween(firstRank: 'aaa', secondRank: 'ccc'), equals('bbb'));
      expect(lexo.getRankBetween(firstRank: 'ddddd', secondRank: 'fffff'), equals('eeeee'));
      expect(lexo.getRankBetween(firstRank: 'aaaaa', secondRank: 'adjww'), equals('abryl'));
    });

    test('should reorder the rank and generate correctly', () {
      final lexo = const LexoRank(reorderPosition: true);
      expect(lexo.getRankBetween(firstRank: 'c', secondRank: 'a'), equals('b'));
      expect(lexo.getRankBetween(firstRank: 'ccc', secondRank: 'aaa'), equals('bbb'));
      expect(lexo.getRankBetween(firstRank: 'fffff', secondRank: 'ddddd'), equals('eeeee'));
      expect(lexo.getRankBetween(firstRank: 'adjww', secondRank: 'aaaaa'), equals('abryl'));
    });

    test('should make the rank same size', () {
      final lexo = const LexoRank();
      expect(lexo.getRankBetween(firstRank: 'aaa', secondRank: 'c'), equals('baa'));
      expect(lexo.getRankBetween(firstRank: 'a', secondRank: 'ccc'), equals('bbb'));
      expect(lexo.getRankBetween(firstRank: 'ddd', secondRank: 'fffff'), equals('eeecp'));
      expect(lexo.getRankBetween(firstRank: 'a', secondRank: 'adjww'), equals('abryl'));
      expect(lexo.getRankBetween(firstRank: 'aa', secondRank: 'adjww'), equals('abryl'));
    });

    test('when ranks are close together or close to a', () {
      final lexo = const LexoRank();
      expect(lexo.getRankBetween(firstRank: 'aaaa', secondRank: 'aaab'), equals('aaaan'));
    });
  });
}
