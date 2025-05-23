import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

var _personHelper = LexoRankListHelper(
  getId: (Person p) => p.id,
  getRankStr: (Person p) => p.rank,
  setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
);

void main() {
  group("moveItemInList", () {
    test("0 ", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var newList = _personHelper.moveItemInList(people, people[3], MoveDirection.up);

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "boo"),
        Person(3, "Doe", 28, "ccc"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      expect(newList.toString(), expected.toString());
    });
  });

  group("moveItems", () {
    test("0 move single", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var newList = _personHelper.moveItemsInList(people, [people[3]], MoveDirection.up);

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      expect(newList.toString(), expected.toString());
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

      var newList = _personHelper.moveItemsInList(
        people,
        [people[3], people[4], people[5]],
        MoveDirection.up,
      );

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
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

      var newList = _personHelper.moveItemsInList(
        people,
        [people[0], people[1]],
        MoveDirection.down,
      );

      var expected = [
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(1, "Rich", 30, "bfffffffffff"),
        Person(2, "Mine", 25, "bggggggggggg"),
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

      var newList = _personHelper.moveItemsInList(people, [people[0], people[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down).list;
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up).list;

      var expected = [
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
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

      var newList = _personHelper.moveItemsInList(
        people,
        [people[3], people[4]],
        MoveDirection.down,
      );

      var expected = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(3, "Doe", 28, "xxxx"),
        Person(5, "Emily", 22, "yllllllllllk"),
        Person(6, "Michael", 40, "yyyyyyyyyyyy"),
      ];

      expect(newList.toString(), expected.toString());
    });

    test("5 bug - moving bottom up", () {
      var people = [
        Person(2, "Mine", 25, "aaaaaaaaannn"),
        Person(1, "Rich", 30, "aaaaaaaabbbb"),
        Person(3, "Doe", 28, "gggggggggggg"),
      ];

      var newList = _personHelper.moveItemsInList(
        people,
        [
          Person(3, "Doe", 28, "gggggggggggg"),
        ],
        MoveDirection.up,
      );

      var expected = [
        Person(2, "Mine", 25, /**/ "aaaaaaaaannn"),
        Person(3, "Doe", 28, /* */ "aaaaaaaaappp"),
        Person(1, "Rich", 30, /**/ "aaaaaaaabbbb"),
      ];

      expect(newList.list.toString(), expected.toString());
    });
  });

  group("createPositionedRank", () {
    test("0 none in list, none selected", () {
      var people = <Person>[];

      var result = _personHelper.createPositionedRank(people, null);

      expect(result, "mmmmmmmmmmmm");
    });

    test("1 one in list, no selected", () {
      var people = <Person>[
        Person(1, "Rich", 30, "mmmmmmmmmmmm"),
      ];

      var result = _personHelper.createPositionedRank(people, null);

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

      var result = _personHelper.createPositionedRank(people, 6);

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

      var result = _personHelper.createPositionedRank(people, null);

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

      var result = _personHelper.createPositionedRank(people, 4);

      expect(result, "bgcwjjjjjjji");
    });

    //add multiple, mid
    test("4 multi in list, mid selected", () {
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
        var result = _personHelper.createPositionedRank(people, idToAddAfter);
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
        idToAddAfter = i;
      }

      people.forEach((x) => print(x));
      // expect(result, "bgcwjjjjjjji");
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
        var result = _personHelper.createPositionedRank(people, null);
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      expect(people.length, 99);
      expect(people.toSet().length, people.length);
      expect(people[98].rank, "zzzzzzzzzzzyzzzzzzzn");
    });

    test("6 add multi then rebalance", () {
      var people = <Person>[
        Person(1, "Rich", 30, "agtttttttttt"),
        Person(2, "Mine", 25, "annnnnnnnnnn"),
        Person(4, "Smith", 35, "bekxxxxxxxxx"),
        Person(5, "Emily", 22, "bhuuuuuuuuuu"),
        Person(6, "Michael", 40, "booooooooooo"),
        Person(3, "Doe", 28, "ccc"),
      ];

      for (var i = 7; i < 100; ++i) {
        var result = _personHelper.createPositionedRank(people, null);
        var newPerson = Person(i, "XXX $i", 99, result);
        people.add(newPerson);
        people = people.sortedBy((x) => x.rank).toList();
      }

      //rebalance
      final lexo = const LexoRank();
      var newList = lexo.generateInitialRank(sizeOfItems: people.length);
      for (var i = 0; i < people.length; ++i) {
        var newPerson = people[i].copyWith(rank: newList[i]);
        people[i] = newPerson;
      }

      expect(people[69].rank, "nuhhg");
      expect(people[98].rank, "tmzzz");
    });
  });
}

class Person {
  int id;
  String name;
  int age;
  String rank;

  Person(this.id, this.name, this.age, this.rank);

  @override
  String toString() => //
      'Person{id: $id, name: $name, age: $age, rank: $rank}';

  Person copyWith({int? id, String? name, int? age, String? rank}) => //
      Person(id ?? this.id, name ?? this.name, age ?? this.age, rank ?? this.rank);
}
