import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';
import 'package:test/test.dart';

void main() {
  group("genInitialRank2", () {
    test("0 a", () {
      // create a list of 10 items with null values
      var input = List<String?>.filled(10, null);

      // fill the first and last items with non-null values
      input[0] = "addeeff";
      input[9] = "mydsfsd";

      // the result of findLargestGap will be a tuple of the start and end indices of the largest gap
      var result = findLargestGap(input);

      expect(result, (start: 0, end: 9));
    });

    test("0 b", () {
      var input = List<String?>.filled(10, null);

      input[0] = "addeeff";
      input[4] = "efsdfkj";
      input[9] = "mydsfsd";

      var result = findLargestGap(input);

      expect(result, (start: 4, end: 9));
    });

    test("0 c", () {
      var input = List<String?>.filled(10, null);

      input[0] = "addeeff";
      input[4] = "efsdfkj";
      input[6] = "glksdfo";
      input[9] = "mydsfsd";

      var result = findLargestGap(input);

      expect(result, (start: 0, end: 4));
    });

    test("0 d all items filled should return null", () {
      var input = List<String?>.filled(10, 'sdf');

      var result = findLargestGap(input);

      expect(result, null);
    });
  });
}
