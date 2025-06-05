import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:test/test.dart';

import '../support/Person.dart';

void main() {
  var _helper = LexoRankListHelper(
    getId: (Person p) => p.id,
    getRankStr: (Person p) => p.rank,
    setRankStr: (Person p, String newRank) => p.copyWith(rank: newRank),
  );

  _getPeople4() => <Person>[
        Person(0, "Alex", 30, "aaab"),
        Person(1, "Rich", 30, "aab"),
        Person(2, "Mine", 25, "aad"),
        Person(4, "Dann", 35, "aag"),
      ];

  group("getBoundsAdding", () {
    test("adding when no records exist", () {
      var result = _helper.getBoundsAdding(
        [],
        [],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'm');
      expect(result.rankBelowNew, 'o');
    });

    test("adding up when none selected", () {
      var result = _helper.getBoundsAdding(
        [
          Person(4, "Dann", 35, "aag"),
        ],
        [],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaa');
      expect(result.rankBelowNew, 'aag');
    });

    test("adding down when none selected", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aag');
      expect(result.rankBelowNew, 'zzzz');
    });

    test("adding up when one record", () {
      var result = _helper.getBoundsAdding(
        [
          Person(2, "Mine", 25, "aad"),
        ],
        [
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaa');
      expect(result.rankBelowNew, 'aad');
    });

    test("adding down when one record", () {
      var result = _helper.getBoundsAdding(
        [
          Person(2, "Mine", 25, "aad"),
        ],
        [
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aad');
      expect(result.rankBelowNew, 'zzz');
    });

    test("adding up from first when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(0, "Alex", 30, "aaab"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaaa');
      expect(result.rankBelowNew, 'aaab');
    });

    test("adding down from bottom when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(4, "Dann", 35, "aag"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aag');
      expect(result.rankBelowNew, 'zzzz');
    });

    test("adding down from first when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(0, "Alex", 30, "aaab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aaab');
      expect(result.rankBelowNew, 'aab');
    });

    test("adding up from middle when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(0, "Alex", 30, "aaab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aaab');
      expect(result.rankBelowNew, 'aab');
    });

    test("adding down from middle when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aab');
      expect(result.rankBelowNew, 'aad');
    });

    test("adding up from bottom when multi records", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(4, "Dann", 35, "aag"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aad');
      expect(result.rankBelowNew, 'aag');
    });

    test("adding up from middle when multi selected", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.up,
      );

      expect(result.rankAboveNew, 'aaab');
      expect(result.rankBelowNew, 'aab');
    });

    test("adding down from middle when multi selected", () {
      var result = _helper.getBoundsAdding(
        _getPeople4(),
        [
          Person(1, "Rich", 30, "aab"),
          Person(2, "Mine", 25, "aad"),
        ],
        EDirection.down,
      );

      expect(result.rankAboveNew, 'aad');
      expect(result.rankBelowNew, 'aag');
    });
  });
}
