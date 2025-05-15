import 'package:dartx/dartx_io.dart';
import 'package:lexo_rank_generator/src/helpers.dart';
import 'package:test/test.dart';

// Person moveUpInListSinglePerson(
//   List<Person> list,
//   Person person,
// ) =>
//     moveUpInListSingleItem<Person, int>(
//       list,
//       person,
//       (Person p) => p.id,
//       (Person p) => p.rank,
//       (String newRank) => Person(
//         person.id,
//         person.name,
//         person.age,
//         newRank,
//       ),
//     );

var _personHelper = LexoRankListHelper(
  getId: (Person p) => p.id,
  getRankStr: (Person p) => p.rank,
  setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
);

void main() {
  group("moveUpInListSingleItem", () {
    test("0 ", () {
      var people = [
        Person(1, "John", 30, "aaa"),
        Person(2, "Jane", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var newList = _personHelper.moveItemInList(people, people[3], MoveDirection.up);

      var expected = [
        Person(1, "John", 30, "aaa"),
        Person(2, "Jane", 25, "bbb"),
        Person(4, "Smith", 35, "boo"),
        Person(3, "Doe", 28, "ccc"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
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

  Person copyWith({
    int? id,
    String? name,
    int? age,
    String? rank,
  }) {
    return Person(
      id ?? this.id,
      name ?? this.name,
      age ?? this.age,
      rank ?? this.rank,
    );
  }
}
