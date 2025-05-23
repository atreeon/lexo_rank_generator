import 'package:lexo_rank_generator/src/generateInitialRank2.dart';
import 'package:test/test.dart';

void main() {
  group("generateInitialRank2", () {
    test("0 a", () {
      var result = generateInitialRank2();

      var expected = [
      ];
      expect(result, expected);
    });
  });
}
