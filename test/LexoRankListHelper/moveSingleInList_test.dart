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
  group("LexoRankListHelper moveSingleInList", () {
    test("0 move single up", () {
      var people = [
        Person(1, "Rich", 30, "aaa"),
        Person(2, "Mine", 25, "bbb"),
        Person(3, "Doe", 28, "ccc"),
        Person(4, "Smith", 35, "ddd"),
        Person(5, "Emily", 22, "eee"),
        Person(6, "Michael", 40, "fff"),
      ];

      var result = _personHelper.moveSingleInList(people, people[3], MoveDirection.up);

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
  });
}
