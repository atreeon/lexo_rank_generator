import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';
import 'package:test/test.dart';

import '../support/Person.dart';

var _personHelper = LexoRankListHelper(
  getId: (Person p) => p.id,
  getRankStr: (Person p) => p.rank,
  setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
  // minRankLengthForNewList: 12,
);

void main() {
  group("LexoRankListHelper newRankForNewRecord", () {
    test("0 none in list, none selected", () {
      var people = <Person>[];

      var result = _personHelper.newRankForNewRecord(people, [], EDirection.down);

      expect(result, "n");
    });

    test("1 one in list, no selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "mmmmmmmmmmmm"),
      ];

      var result = _personHelper.newRankForNewRecord(people, [], EDirection.down);

      expect(result, "tggggggggggf");
    });

    test("2 multi in list, last selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var result = _personHelper.newRankForNewRecord(
        people,
        [
          Person(6, "Michael", 40, "fff"),
        ],
        EDirection.down,
      );

      expect(result, "ppp");
    });

    test("3 multi in list, none selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(3, "Doe", 28, "xxxx"),
        Person(5, "Emily", 22, "yllllllllllk"),
        Person(6, "Michael", 40, "yyyyyyyyyyyy"),
      ];

      var result = _personHelper.newRankForNewRecord(
        people,
        [],
        EDirection.down,
      );

      expect(result, "zmmmmmmmmmml");
    });

    test("4a multi in list, mid selected 2", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      var result = _personHelper.newRankForNewRecord(
        people,
        [
          Person(4, "Smith", 35, "bekxxxxxxxxx"),
        ],
        EDirection.down,
      );

      expect(result, "bgcwjjjjjjji");
    });

    //add multiple, mid
    test("4b multi in list, mid selected, add 30 new", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      var idToAddAfter = 4;
      for (var i = 7; i < 30; ++i) {
        var result = _personHelper.newRankForNewRecord(
          people,
          [people.firstWhere((x) => x.id == idToAddAfter)],
          EDirection.down,
        );
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
        idToAddAfter = i;
      }

      expect(people.map((x) => x.rank).toSet().length, people.length);
      expect(people[13].rank, 'bhutrupxcpep');
    });

    test("5 add multi, last (no id)", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      for (var i = 7; i < 100; ++i) {
        var result = _personHelper.newRankForNewRecord(
          people,
          [],
          EDirection.down,
        );
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      expect(people.length, 99);
      expect(people.toSet().length, people.length);
      expect(people[98].rank, "zzzzzzzzzzzzzzzzyn");
    });

    test("6 add multi and then rebalance", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      for (var i = 7; i < 100; ++i) {
        var result = _personHelper.newRankForNewRecord(
          people,
          [],
          EDirection.down,
        );
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      //rebalance
      var newList = getRankBetweenMulti(sizeOfItems: people.length, startRankLetter: 'a', endRankLetter: 'z');
      for (var i = 0; i < people.length; ++i) {
        var newPerson = people[i].copyWith(rank: newList[i]);
        people[i] = newPerson;
      }

      expect(people[69].rank, "qt");
      expect(people[98].rank, "z");
    });

    test("7 bug when first rank is 'a' or 'aa'", () {
      var people = <Person>[
        Person(1, "Rich", 30, "aa"),
        Person(2, "Mine", 25, "aad"),
        Person(4, "Smith", 35, "aag"),
      ];

      try {
        _personHelper.moveMulti(
          people,
          [
            Person(2, "Mine", 25, "aad"),
          ],
          EDirection.up,
        );
      // ignore: unused_catch_clause
      } on LexoRankException catch (e) {
        // print(e);
        expect(true, true);
        return;
      }

      throw Exception('should throw an LexoRankException');
    });

    test("8 we create lots, then delete all the prior ones leaving a high number, then create another below", () {
      var people = <Person>[];

      for (var i = 1; i < 100; ++i) {
        var result = _personHelper.newRankForNewRecord(
          people,
          [],
          EDirection.down,
        );
        var newPerson = Person(i, "XXX $i", 0, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      //delete all but the very last one
      people = people.skip(98).toList();

      //add another one after the last one
      var result = _personHelper.newRankForNewRecord(
        people,
        [],
        EDirection.down,
      );

      expect(result, 'zzzzzzzzzzzzzzu');
    });

    test("9 add multi UP top", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      for (var i = 7; i < 100; ++i) {
        var result = _personHelper.newRankForNewRecord(
          people,
          [],
          EDirection.up,
        );
        var newPerson = Person(i, "XXX $i", 99, result);
        people.insert(0, newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      expect(people.length, 99);
      expect(people.toSet().length, people.length);
      expect(people[0].rank, "aaaaaaaaaaaaaaaaaaaaaab");
    });
  });
}
