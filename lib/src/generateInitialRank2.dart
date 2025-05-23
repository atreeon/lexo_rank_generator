import 'package:dartx/dartx.dart';

List<String> generateInitialRank2({
  required int sizeOfItems,
  int rankLength = 5,
  String startRankLetter = 'a',
  String endRankLetter = 'z',
}) {
  throw UnimplementedError('This function is not implemented yet.');
}

final int baseCodeValue = 'a'.codeUnits.first;

int totalValueOfString({
  required String myString,
  required int precision,
}) {
  myString.codeUnits.fold(0, (runningTotal,fromList) {
    return runningTotal + fromList - baseCodeValue;
  });
}

int totalValueOfString({
  String startRankLetter = 'a',
  String endRankLetter = 'z',
}) {
  var startRankPos = startRankLetter.codeUnits.first;
  var endRankPos = endRankLetter.codeUnits.first;

  var totalLength = [startRankLetter.length, endRankLetter.length].max()!;
  var i = 0;

  while(i < totalLength){
    i++;


    startRankLetter = startRankLetter.substring(1);
    endRankLetter = endRankLetter.substring(1);

    startRankPos = startRankLetter.codeUnits.first;
    endRankPos = endRankLetter.codeUnits.first;

  }
}
