import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

void main() {
  group("mytests", () {
    test("0 ", () {
      final lexo = const LexoRank();

      var list = lexo.generateInitialRank(sizeOfItems: 30);
      list.forEach((x) => print(x));
    });

    test("1", () {
      final lexo = const LexoRank();
      String secondRank = 'c';
      final items = <String>[];
      for (int i = 0; i < 100; i++) {
        final rank = lexo.getRankBetween(firstRank: 'a', secondRank: secondRank);
        secondRank = rank;
        items.add(rank);
      }

      items.forEach((x) => print(x));

      final stats = lexo.shouldRebalanced(items, maxRankLength: 20);
      print(stats);
    });

    test("previous", () {
      final lexo = const LexoRank();
      final rank = lexo.prevLexo('aabbb');

      print(rank);

      //prob don't do the above, always compare to the beggining of the string
      final rank2 = lexo.getRankBetween(firstRank: "a", secondRank: 'aabbb');
      print(rank2);
    });

    test("next", () {
      final lexo = const LexoRank();
      final rank2 = lexo.getRankBetween(firstRank: 'xyz', secondRank: 'zzz');
      print(rank2);
    });

    test("next when close", () {
      final lexo = const LexoRank();
      final rank2 = lexo.getRankBetween(firstRank: 'zzy', secondRank: 'zzz');
      print(rank2);
    });

    test("emergency rebalance", () {
      final lexo = const LexoRank();
      String secondRank = 'c';
      final items = <String>[];
      for (int i = 0; i < 100; i++) {
        final rank = lexo.getRankBetween(firstRank: 'a', secondRank: secondRank);
        secondRank = rank;
        items.add(rank);
        final stats = lexo.shouldRebalanced(items, maxRankLength: 20);

        print(rank);

        if (stats.exceededPercent > 0.2) {
          print("emergency rebalance required at $i");
        }

        if (stats.exceededPercent > 0.05) {
          print("maintainance rebalance required at $i");
        }
      }
      // items.forEach((x) => print(x));
    });

    test("move up in list", () {
      final lexo = const LexoRank();
      var list = lexo.generateInitialRank(sizeOfItems: 10);

      list.forEach((x) => print(x));

      //move list[5] above list[4]
      var newId = lexo.getRankBetween(firstRank: list[3], secondRank: list[4]);

      list[5] = newId;
      list.sort();

      list.forEach((x) => print(x));
    });

    test("generateInitialRank", () {
      final lexo = const LexoRank();
      var list = lexo.generateInitialRank(sizeOfItems: 500, rankLength: 10, startRankLetter: 'aaa', endRankLetter: 'zzz');
      list.forEach((x) => print(x));
    });
  });
}
