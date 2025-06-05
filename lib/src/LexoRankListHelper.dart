import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';

enum EDirection { up, down }

/// A helper class to move items in a list
///
/// We don't check to see if the item is in the list
/// nor if we are trying to move items outside of the bounds of the list.
/// These actions should be done before calling this class.
class LexoRankListHelper<T, TId> {
  final TId Function(T) getId;
  final String Function(T) getRankStr;
  final T Function(T, String) setRankStr;

  LexoRankListHelper({
    required this.getId,
    required this.getRankStr,
    required this.setRankStr,
  });

  String newRankForNewRecord(List<T> list, List<T> selectedItems, EDirection direction) {
    final lexo = const LexoRank();

    var getBounds = getBoundsAdding(list, selectedItems, direction);

    var newRank = lexo.getRankBetween(firstRank: getBounds.rankAboveNew, secondRank: getBounds.rankBelowNew);
    return newRank;
  }

  /// Moves multiple items in a list of items
  ({List<T> list, List<T> itemsMoved}) moveMultiInList(List<T> list, List<T> itemsToMove, EDirection moveDirection) {
    var newItems = moveMulti(list, itemsToMove, moveDirection);

    var updatedList = list //
        .map((x) => newItems.firstOrNullWhere((y) => getId(x) == getId(y)) != null ? newItems.firstWhere((y) => getId(x) == getId(y)) : x)
        .sortedBy((x) => getRankStr(x))
        .toList();
    return (list: updatedList, itemsMoved: newItems);
  }

  /// If we move multiple items
  /// We take the first item to be moved and then move all our items above that one
  List<T> moveMulti(
    List<T> list,
    List<T> itemsToMove,
    EDirection direction,
  ) {
    if (list.isEmpty || itemsToMove.isEmpty) {
      throw LexoRankException('Cannot move items, list or itemsToMove is empty');
    }

    final lexo = const LexoRank();

    var bounds = getBoundsMoving(list, itemsToMove, direction);

    if (itemsToMove.length > 1) {
      var ranks = getRankBetweenMulti(
        sizeOfItems: itemsToMove.length + 2,
        startRankLetter: bounds.rankAboveNew,
        endRankLetter: bounds.rankBelowNew,
      );

      var newItems = itemsToMove.map((item) {
        var itemId = getId(item);
        var index = itemsToMove.indexWhere((x) => getId(x) == itemId);
        var rank = ranks[index + 1];
        return setRankStr(item, rank);
      }).toList();

      return newItems;
    } else {
      assert(itemsToMove.length == 1, 'itemsToMove should only contain one now');

      var newRank = lexo.getRankBetween(firstRank: bounds.rankAboveNew, secondRank: bounds.rankBelowNew);
      var newItem = setRankStr(itemsToMove.first, newRank);
      var newItems = [newItem];
      return newItems;
    }
  }

  /// Gets the rank above and below the selected items
  ///
  /// If we get to the top we return a number of 'aaa's
  ///
  /// If we get to the bottom we return a number of 'zzz's
  ///
  /// These will then be used by the [LexoRank.getRankBetween] function
  ///   or our own [getRankBetweenMulti]
  ({String rankAboveNew, String rankBelowNew}) getBoundsMoving(
    List<T> list,
    List<T> itemsToMove,
    EDirection direction, {
    bool createNewRow = false,
  }) {
    assert(itemsToMove.isNotEmpty, 'itemsToMove cannot be empty');

    var firstToMoveIndex = list.indexWhere((x) => getId(x) == getId(itemsToMove.first));
    var lastToMoveIndex = list.indexWhere((x) => getId(x) == getId(itemsToMove.last));

    assert(!(firstToMoveIndex == 0 && direction == EDirection.up), 'Cannot move up from the first item');
    assert(!(lastToMoveIndex == list.length - 1 && direction == EDirection.down), 'Cannot move down from the last item');

    var moveToPositionIndex = direction == EDirection.up ? firstToMoveIndex : lastToMoveIndex;

    var aboveNewPositionIndex = moveToPositionIndex + (direction == EDirection.up ? -2 : 1);
    var belowNewPositionIndex = moveToPositionIndex + (direction == EDirection.up ? -1 : 2);

    var rankLength = [
      aboveNewPositionIndex < 0 ? 0 : getRankStr(list[aboveNewPositionIndex]).length,
      belowNewPositionIndex >= list.length ? 0 : getRankStr(list[belowNewPositionIndex]).length,
    ].max()!;

    var rankAboveNew = aboveNewPositionIndex < 0 //
        ? List.generate(rankLength, (_) => 'a').join()
        : getRankStr(list[aboveNewPositionIndex]);

    var rankBelowNew = belowNewPositionIndex >= list.length //
        ? List.generate(rankLength, (_) => 'z').join()
        : getRankStr(list[belowNewPositionIndex]);

    return (rankAboveNew: rankAboveNew, rankBelowNew: rankBelowNew);
  }

  /// note: if adding and there are sub tasks that are collapse, then we fudge things and pass in a different itemsToMove list.
  ///
  ({String rankAboveNew, String rankBelowNew}) getBoundsAdding(
    List<T> list,
    List<T> itemsToMove,
    EDirection direction,
  ) {
    if (list.isEmpty) {
      return (rankAboveNew: 'm', rankBelowNew: 'o');
    }

    var rankLength = list.map((x) => getRankStr(x).length).max()!;

    if (direction == EDirection.up) {
      if (itemsToMove.isEmpty || getId(itemsToMove.first) == getId(list.first)) {
        var rankStart = List.generate(rankLength, (_) => 'a').join();
        return (rankAboveNew: rankStart, rankBelowNew: getRankStr(list.first));
      }
    }

    // if none selected & down we add to bottom or we are adding to the top or bottom
    if (direction == EDirection.down) {
      if (itemsToMove.isEmpty || (getId(itemsToMove.last) == getId(list.last))) {
        var rankEnd = List.generate(rankLength, (_) => 'z').join();
        return (rankAboveNew: getRankStr(list.last), rankBelowNew: rankEnd);
      }
    }

    if (direction == EDirection.down) {
      // if adding down we need to get the last selected item
      var lastSelected = itemsToMove.last;

      //there will be a next because we have caught above where there are none above
      var indexOfNext = list.indexWhere((x) => getId(lastSelected) == getId(x)) + 1;
      var next = getRankStr(list[indexOfNext]);

      return (rankAboveNew: getRankStr(lastSelected), rankBelowNew: next);
    }

    if (direction == EDirection.up) {
      var firstSelected = itemsToMove.first;

      //there will be a next because we have caught above where there are none above
      var indexOfPrevious = list.indexWhere((x) => getId(firstSelected) == getId(x)) - 1;
      var previous = getRankStr(list[indexOfPrevious]);

      return (rankAboveNew: previous, rankBelowNew: getRankStr(firstSelected));
    }

    throw Exception('unexpected result');
  }
}
