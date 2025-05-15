import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group("generateInitialRank", () {
    test("the first characters can be the same", () {
      final lexo = const LexoRank();
      var list = lexo.generateInitialRank(sizeOfItems: 100, rankLength: 12, startRankLetter: 'aaaa', endRankLetter: 'aac');

      //check length
      expect(list.length, 100);
      expect(list.toSet().length, list.length);

      //check length of rank is correct
      list.forEach((x) => expect(x.length, 12));

      expect(list[0].substring(0, 3), 'aaa');
      expect(list[99].substring(0, 3), 'aab');
    });
  });
}
