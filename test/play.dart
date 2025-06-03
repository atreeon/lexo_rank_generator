// ignore_for_file: deprecated_member_use_from_same_package

import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

import 'support/EList.dart';
import 'support/Person.dart';

void main() {
  group("mytests", () {
    test("0 ", () {
      final lexo = const LexoRank();

      var list = lexo.generateInitialRank(sizeOfItems: 30);
      list.printLines();
    });

    test("previous", () {
      final lexo = const LexoRank();

      print(lexo.prevLexo('aabbb'));
      print(lexo.prevLexo('aabba'));
      print(lexo.prevLexo('aabb'));
      print(lexo.prevLexo('aaann'));

      //prob don't do the above, always compare to the beggining of the string
      final rank3 = lexo.getRankBetween(firstRank: "a", secondRank: 'aabbb');
      print(rank3);
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

    test("5 bug - first is a", () {
      var people = [
        Person(1, "Mine", 25, "aaaaaaaaaaaaaa"),
        Person(2, "Rich", 30, "bbb"),
        Person(3, "Doe", 28, "ccc"),
      ];

      var _personHelper = LexoRankListHelper(
        getId: (Person p) => p.id,
        getRankStr: (Person p) => p.rank,
        setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
        minRankLengthForNewList: 12,
      );

      _personHelper.moveMultiInList(
        people,
        [
          Person(2, "Rich", 28, "bbb"),
        ],
        MoveDirection.up,
      );
    });

    test("generateInitialRank", () {
      final lexo = const LexoRank();
      var list = lexo.generateInitialRank(sizeOfItems: 500, rankLength: 10, startRankLetter: 'aaa', endRankLetter: 'zzz');
      list.forEach((x) => print(x));
    });
  });
}
