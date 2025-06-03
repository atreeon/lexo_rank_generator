import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

import '../support/Person.dart';

var _personHelper = LexoRankListHelper(
  getId: (Person p) => p.id,
  getRankStr: (Person p) => p.rank,
  setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
  minRankLengthForNewList: 12,
);

void main() {
  group("LexoRankListHelper moveMultiInList", () {
    test("0.5 move single", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var result = _personHelper
          .moveMultiInList(
            people,
            [people[3]],
            MoveDirection.up,
          )
          .list;

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "boo"),
        Person(3, "Doe", 28, "ccc"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      expect(result.toString(), expected.toString());
    });

    test("1 move three up", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var newList = _personHelper
          .moveMultiInList(
            people,
            [people[3], people[4], people[5]],
            MoveDirection.up,
          )
          .list;

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bhu"),
        Person(5, "Emily", 22, "boo"),
        Person(6, "Michael", 40, "bvi"),
        Person(3, "Doe", 28, "ccc"),
      ];

      expect(newList.toString(), expected.toString());
    });

    test("2 move top two down", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      //move Rich and Mine down
      var newList = _personHelper
          .moveMultiInList(
            people,
            [people[0], people[1]],
            MoveDirection.down,
          )
          .list;

      var expected = [
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(1, "Rich", 30, "bgcwjjjjjjji"),
        Person(2, "Mine", 25, "bgyvpccccccb"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      expect(newList.toString(), expected.toString());
    });

    test("3 move top two down & up over and over", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      var newList = _personHelper.moveMultiInList(people, [people[0], people[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveMultiInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveMultiInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveMultiInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveMultiInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveMultiInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveMultiInList(newList, [newList[1], newList[2]], MoveDirection.up).list;

      var expected = [
        Person(1, "Rich", 30, "apflyyyyyyyy"),
        Person(2, "Mine", 25, "awveyllllllk"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      expect(newList.toString(), expected.toString());
    });

    test("4 move two to bottom", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "xxxx"),
      ];

      //move Emily and Michael down
      var newList = _personHelper
          .moveMultiInList(
            people,
            [people[3], people[4]],
            MoveDirection.down,
          )
          .list;

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(3, "Doe", 28, "xxxx"),
        Person(5, "Emily", 22, "yyyymzzzzzzz"),
        Person(6, "Michael", 40, "zmmmgmzzzzzz"),
      ];

      expect(newList.toString(), expected.toString());
    });

    test("5 bug - moving bottom up", () {
      var people = [
        Person(2, "Mine", 25, "aaaaaaaaannn"),
        Person(1, "Rich", 30, "aaaaaaaabbbb"),
        Person(3, "Doe", 28, "gggggggggggg"),
      ];

      var newList = _personHelper.moveMultiInList(
        people,
        [
          Person(3, "Doe", 28, "gggggggggggg"),
        ],
        MoveDirection.up,
      );

      var expected = [
        Person(2, "Mine", 25, /**/ "aaaaaaaaannn"),
        Person(3, "Doe", 28, /* */ "aaaaaaaaauhh"),
        Person(1, "Rich", 30, /**/ "aaaaaaaabbbb"),
      ];

      expect(newList.list.toString(), expected.toString());
    });

    test("5 bug - first is a", () {
      var people = [
        Person(1, "Mine", 25, "aaaaaaaaaaaaaa"),
        Person(2, "Rich", 30, "bbb"),
        Person(3, "Doe", 28, "ccc"),
      ];

      try {
        _personHelper.moveMultiInList(
          people,
          [
            Person(2, "Rich", 28, "bbb"),
          ],
          MoveDirection.up,
        );
      } on LexoRankException {
        expect(true, true);
        return;
      }

      throw Exception('should throw an LexoRankException, cannot move above aaa');
    });

    test('keep moving items up', () {
      //in reality this should get caught by the rebalancer
      final lexo = const LexoRank();
      final items = lexo.generateInitialRank(
        sizeOfItems: 10000,
        rankLength: 12,
        startRankLetter: 'b',
        endRankLetter: 'y',
      );

      var people = items.mapIndexed((i, x) => Person(i, 'Person', 1, x)).toList();

      for (var i = 0; i < 250; ++i) {
        //move the 2nd & 3rd items to the top
        var result = _personHelper.moveMultiInList(
          people,
          [people[1], people[2]],
          MoveDirection.up,
        );
        people = result.list;
      }

      expect(people[0].rank, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaad');
    });
  });
}
