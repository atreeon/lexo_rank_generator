import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

import '../support/Person.dart';

void main() {
  var _helper = LexoRankListHelper(
    getId: (Person p) => p.id,
    getRankStr: (Person p) => p.rank,
    setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
  );

  getPeople4() => <Person>[
        Person(0, "Alex", 30, "aaab"),
        Person(1, "Rich", 30, "aab"),
        Person(2, "Mine", 25, "aad"),
        Person(4, "Smith", 35, "aag"),
      ];

  getPeople2() => <Person>[
        Person(0, "Alex", 30, "aaab"),
        Person(1, "Rich", 30, "aab"),
      ];

  group("getRankAboveAndBelow", () {
    test("up from bottom", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [Person(4, "Smith", 35, "aag")],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aab');
      expect(result.rankBelowNew, 'aad');
    });

    test("up from 2nd bottom", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [Person(2, "Mine", 25, "aad")],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaab');
      expect(result.rankBelowNew, 'aab');
    });

    test("up from 2nd top", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaaa');
      expect(result.rankBelowNew, 'aaab');
    });

    test("down from 2nd bottom", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aag');
      expect(result.rankBelowNew, 'zzz');
    });

    test("down from 2nd top", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aad');
      expect(result.rankBelowNew, 'aag');
    });

    test("down from top", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(0, "Alex", 30, "aaab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aab');
      expect(result.rankBelowNew, 'aad');
    });

    test("up from bottom when only two records", () {
      var result = _helper.getBoundsMoving(
        getPeople2(),
        [
          Person(1, "Rich", 30, "aab"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaaa');
      expect(result.rankBelowNew, 'aaab');
    });

    test("down from top when only two records", () {
      var result = _helper.getBoundsMoving(
        getPeople2(),
        [
          Person(0, "Alex", 30, "aaab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aab');
      expect(result.rankBelowNew, 'zzz');
    });

    test("multi bottom up", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(2, "Mine", 25, "aad"),
          Person(4, "Smith", 35, "aag"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaab');
      expect(result.rankBelowNew, 'aab');
    });

    test("multi 2nd top to top", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaaa');
      expect(result.rankBelowNew, 'aaab');
    });

    test("multi top down", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(0, "Alex", 30, "aaab"),
          Person(1, "Rich", 30, "aab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aad');
      expect(result.rankBelowNew, 'aag');
    });

    test("multi 2nd bottom to bottom", () {
      var result = _helper.getBoundsMoving(
        getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aag');
      expect(result.rankBelowNew, 'zzz');
    });
  });
}
