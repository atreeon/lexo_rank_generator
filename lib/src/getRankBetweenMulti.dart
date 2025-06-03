import 'package:lexo_rank_generator/lexo_rank_generator.dart';

/// Pass two rank values & the number of items (including the two ranks you passed)
///
/// Returns a list of ranks that are evenly distributed between the two ranks.
///
/// WARNING!!! The result may not look so much in sequence due to the way [findLargestGap] works
///
/// ie ['aaa', 'ddd'] should return ['aaa', 'bbb', 'ccc', 'ddd']
/// but it doesn't it return ['aaa', 'boo', 'civ', 'ddd']
/// due to the way the gaps are found and filled.
List<String> getRankBetweenMulti({
  required int sizeOfItems,
  required String startRankLetter,
  required String endRankLetter,
}) {
  // print('getRankBetweenMulti: sizeOfItems: $sizeOfItems, startRankLetter: $startRankLetter, endRankLetter: $endRankLetter');

  //liketo: distribute the ranks evenly
  //3*26 + 10 == 88 -> two splits at 29
  //bek
  //bfn
  //bgq
  //bhu

  final lexo = const LexoRank();

  //create the list of items
  var result = List<String?>.filled(sizeOfItems, null);
  result[0] = startRankLetter;
  result[sizeOfItems - 1] = endRankLetter;

  ({int end, int start})? nextGap;
  while (true) {
    nextGap = findLargestGap(result);

    if (nextGap == null) {
      break;
    }

    var newRank = lexo.getRankBetween(firstRank: result[nextGap.start]!, secondRank: result[nextGap.end]!);
    var middleIndex = (nextGap.start + nextGap.end) ~/ 2;
    result[middleIndex] = newRank;
  }

  return result.map((x) => x as String).toList();
}

/// Returns the tuple (startIndex, endIndex) where:
/// - startIndex: index of the last non-null string before the gap
/// - endIndex: index of the first non-null string after the gap
/// The function assumes the first and last items are non-null.
({int start, int end})? findLargestGap(List<String?> items) {
  int? lastNonNullIndex;
  int maxGapSize = 0;
  int gapStart = 0;
  int gapEnd = 0;

  for (int i = 0; i < items.length; i++) {
    if (items[i] != null) {
      if (lastNonNullIndex != null) {
        int gapSize = i - lastNonNullIndex - 1;
        if (gapSize > maxGapSize) {
          maxGapSize = gapSize;
          gapStart = lastNonNullIndex;
          gapEnd = i;
        }
      }
      lastNonNullIndex = i;
    }
  }

  if (maxGapSize == 0) {
    return null;
  }

  return (start: gapStart, end: gapEnd);
}
