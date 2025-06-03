import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';
import 'package:test/test.dart';

import '../support/Person.dart';

var _personHelper = LexoRankListHelper(
  getId: (Person p) => p.id,
  getRankStr: (Person p) => p.rank,
  setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
  minRankLengthForNewList: 12,
);

void main() {
  group("LexoRankListHelper createRankAfterId", () {
    test("0 none in list, none selected", () {
      var people = <Person>[];

      var result = _personHelper.createRankAfterId(people, null);

      expect(result, "mmmmmmmmmmmm");
    });

    test("1 one in list, no selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "mmmmmmmmmmmm"),
      ];

      var result = _personHelper.createRankAfterId(people, null);

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

      var result = _personHelper.createRankAfterId(people, 6);

      expect(result, "pppmzzzzzzzz");
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

      var result = _personHelper.createRankAfterId(people, null);

      expect(result, "zmmmmmmmmmml");
    });

    test("4 multi in list, mid selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      var result = _personHelper.createRankAfterId(people, 4);

      expect(result, "bgcwjjjjjjji");
    });

    //add multiple, mid
    test("4 multi in list, mid selected, add 30 new", () {
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
        var result = _personHelper.createRankAfterId(people, idToAddAfter);
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
        var result = _personHelper.createRankAfterId(people, null);
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      expect(people.length, 99);
      expect(people.toSet().length, people.length);
      expect(people[98].rank, "zzzzzzzzzzzyzzzzzzzn");
    });

    test("6 add multi", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      for (var i = 7; i < 100; ++i) {
        var result = _personHelper.createRankAfterId(people, null);
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
          people.skip(1).toList(),
          MoveDirection.up,
        );
      } on LexoRankException {
        expect(true, true);
        return;
      }

      throw Exception('should throw an LexoRankException');
    });
  });
}
