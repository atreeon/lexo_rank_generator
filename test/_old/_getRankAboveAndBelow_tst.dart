// import 'package:lexo_rank_generator/lexo_rank_generator.dart';
// import 'package:test/test.dart';
//
// void main() {
//   /// getRankAboveAndBelow will be used to refactor
//   group("getRankAboveAndBelow", () {
//     test("1a", () {
//       var personHelper2 = LexoRankListHelper(
//         getId: (Person p) => p.id,
//         getRankStr: (Person p) => p.rank,
//         setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
//         minRankLengthForNewList: 4,
//       );
//
//       var people = <Person>[
//         Person(1, "Rich", 30, "aab"),
//         Person(2, "Mine", 25, "aad"),
//         Person(4, "Smith", 35, "aag"),
//       ];
//
//       var result = personHelper2.getRankAboveAndBelow(
//         people,
//         people.skip(1).toList(),
//         MoveDirection.up,
//       );
//
//       print(result);
//
//     });
//   });
// }
//
// class Person {
//   int id;
//   String name;
//   int age;
//   String rank;
//
//   Person(this.id, this.name, this.age, this.rank);
//
//   @override
//   String toString() => //
//       'Person{id: $id, name: $name, age: $age, rank: $rank}';
//
//   Person copyWith({int? id, String? name, int? age, String? rank}) => //
//       Person(id ?? this.id, name ?? this.name, age ?? this.age, rank ?? this.rank);
// }
