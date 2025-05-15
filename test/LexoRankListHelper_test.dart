import 'package:lexo_rank_generator/src/LexoRankListHelper.dart';
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

      var newList = _personHelper.moveItemsInList(people, [people[0], people[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);
      newList = _personHelper.moveItemsInList(newList, [newList[0], newList[1]], MoveDirection.down);
      newList = _personHelper.moveItemsInList(newList, [newList[1], newList[2]], MoveDirection.up);

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
  });
}

class Person {
  int id;
  String name;
  int age;
  String rank;

  Person(this.id, this.name, this.age, this.rank);

  @override
  String toString() {
    return 'Person{id: $id, name: $name, age: $age, rank: $rank}';
  }

  Person copyWith({int? id, String? name, int? age, String? rank}) {
    return Person(id ?? this.id, name ?? this.name, age ?? this.age, rank ?? this.rank);
  }
}
