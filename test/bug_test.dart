import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group("generateInitialRank", () {
    test("the first characters can be the same", () {
      final lexo = const LexoRank();
      var list = lexo.generateInitialRank(sizeOfItems: 100, rankLength: 12, startRankLetter: 'a', endRankLetter: 'z');
      list.forEach((x) => print(x));
      expect(list.length, 100);

      //check no duplicates
      expect(list.toSet().length, list.length);
    });
  });
}
