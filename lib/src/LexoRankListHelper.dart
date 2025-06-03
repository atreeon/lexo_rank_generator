import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';
import 'package:lexo_rank_generator/src/getRankBetweenMulti.dart';

enum MoveDirection { up, down }

/// A helper class to move items in a list
///
/// We don't check to see if the item is in the list
/// nor if we are trying to move items outside of the bounds of the list.
/// These actions should be done before calling this class.
class LexoRankListHelper<T, TId> {
  final TId Function(T) getId;
  final String Function(T) getRankStr;
  final T Function(T, String) setRankStr;
  final int minRankLengthForNewList;

  LexoRankListHelper({
    required this.getId,
    required this.getRankStr,
    required this.setRankStr,
    this.minRankLengthForNewList = 12,
  });

  /// Creates a new rank AFTER the selected id
  String createRankAfterId(List<T> list, TId? createAfterItemId) {
    if (list.isEmpty) {
      return List.generate(minRankLengthForNewList, (_) => 'm').join();
    }

    final lexo = const LexoRank();

    if (list.length == 1) {
      //regardless if we have one selected or not we will always add it after
      var rankBelow = getRankStr(list.first);
      var rankAfter = List.generate(minRankLengthForNewList, (_) => 'z').join();
      var newRank = lexo.getRankBetween(firstRank: rankBelow, secondRank: rankAfter);
      return newRank;
    }

    createAfterItemId ??= getId(list.last);
    var indexOfCreateAfterItemId = list.indexWhere((x) => getId(x) == createAfterItemId);

    if (indexOfCreateAfterItemId >= list.length - 1) {
      //create after the last item
      var rankBelow = getRankStr(list[indexOfCreateAfterItemId]);
      var rankAfter = List.generate(minRankLengthForNewList, (_) => 'z').join();
      var newRank = lexo.getRankBetween(firstRank: rankBelow, secondRank: rankAfter);
      return newRank;
    }

    var rankBelow = getRankStr(list[indexOfCreateAfterItemId]);
    var rankAfter = getRankStr(list[indexOfCreateAfterItemId + 1]);

    // print('rankBelow: $rankBelow, rankAfter: $rankAfter');

    var newRank = lexo.getRankBetween(firstRank: rankBelow, secondRank: rankAfter);
    return newRank;
  }

  /// Moves an item in a list of items
  /// Returning a new list with the item moved and with a new rank
  List<T> moveSingleInList(List<T> list, T item, MoveDirection moveDirection) {
    var newItem = moveItem(list, item, MoveDirection.up);
    var updatedList = list.map((x) => getId(x) == getId(newItem) ? newItem : x).sortedBy((x) => getRankStr(x)).toList();
    return updatedList;
  }

  /// Moves multiple items in a list of items
  ({List<T> list, List<T> itemsMoved}) moveMultiInList(List<T> list, List<T> itemsToMove, MoveDirection moveDirection) {
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
    MoveDirection direction,
  ) {
    if (list.isEmpty) {
      throw LexoRankException('Minimum of 1 item required');
    }

    final lexo = const LexoRank();
    // var itemId = getId(itemsToMove.first);

    var itemId = direction == MoveDirection.up ? getId(itemsToMove.first) : getId(itemsToMove.last);

    var index = list.indexWhere((x) => getId(x) == itemId);

    var aboveNewPositionIndex = index + (direction == MoveDirection.up ? -2 : 1);
    var belowNewPositionIndex = index + (direction == MoveDirection.up ? -1 : 2);

    // print('aboveNewPositionIndex: $aboveNewPositionIndex, belowNewPositionIndex: $belowNewPositionIndex');

    var rankAboveNew = aboveNewPositionIndex < 0 //
        ? List.generate(minRankLengthForNewList, (_) => 'a').join()
        : getRankStr(list[aboveNewPositionIndex]);

    var rankBelowNew = belowNewPositionIndex >= list.length //
        ? List.generate(minRankLengthForNewList, (_) => 'z').join()
        : getRankStr(list[belowNewPositionIndex]);

    // print('rankAboveNew: $rankAboveNew, rankBelowNew: $rankBelowNew');

    if (direction == MoveDirection.up && rankBelowNew.characters.every((y) => y == 'a')) {
      throw LexoRankException('Cannot move up, rank already at maximum - rankAboveNew: $rankAboveNew, rankBelowNew: $rankBelowNew');
    }

    if (direction == MoveDirection.down && rankAboveNew.characters.every((y) => y == 'z')) {
      throw LexoRankException('Cannot move down, rank already at maximum - rankAboveNew: $rankAboveNew, rankBelowNew: $rankBelowNew');
    }

    if (list.length == 1) {
      var newId = lexo.getRankBetween(firstRank: rankAboveNew, secondRank: rankBelowNew);
      var newItem = setRankStr(itemsToMove.first, newId);
      return [newItem];
    } else {
      var ranks = getRankBetweenMulti(
        sizeOfItems: itemsToMove.length + 2,
        startRankLetter: rankAboveNew,
        endRankLetter: rankBelowNew,
      );

      var newItems = itemsToMove.map((item) {
        var itemId = getId(item);
        var index = itemsToMove.indexWhere((x) => getId(x) == itemId);
        var rank = ranks[index + 1];
        return setRankStr(item, rank);
      }).toList();

      return newItems;
    }
  }

  T moveItem(
    List<T> list,
    T item,
    MoveDirection direction,
  ) {
    final lexo = const LexoRank();
    var itemId = getId(item);
    var index = list.indexWhere((x) => getId(x) == itemId);

    var aboveNewPositionIndex = index + (direction == MoveDirection.up ? -2 : 1);
    var belowNewPositionIndex = index + (direction == MoveDirection.up ? -1 : 2);

    var rankAboveNew = getRankStr(list[aboveNewPositionIndex]);
    var rankBelowNew = getRankStr(list[belowNewPositionIndex]);

    var newId = lexo.getRankBetween(firstRank: rankAboveNew, secondRank: rankBelowNew);

    var newItem = setRankStr(item, newId);

    return newItem;
  }

  /// Possibly used to refactor part of moveItems
// ({String rankAboveNew, String rankBelowNew}) getRankAboveAndBelow(
//   List<T> list,
//   List<T> itemsToMove,
//   MoveDirection direction,
// ) {
//   if (list.isEmpty) {
//     throw LexoRankException('Minimum of 1 item required');
//   }
//
//   var itemId = direction == MoveDirection.up ? getId(itemsToMove.first) : getId(itemsToMove.last);
//
//   var index = list.indexWhere((x) => getId(x) == itemId);
//
//   var aboveNewPositionIndex = index + (direction == MoveDirection.up ? -2 : 1);
//   var belowNewPositionIndex = index + (direction == MoveDirection.up ? -1 : 2);
//
//   var rankAboveNew = aboveNewPositionIndex < 0 //
//       ? List.generate(minRankLengthForNewList, (_) => 'a').join()
//       : getRankStr(list[aboveNewPositionIndex]);
//
//   var rankBelowNew = belowNewPositionIndex >= list.length //
//       ? List.generate(minRankLengthForNewList, (_) => 'z').join()
//       : getRankStr(list[belowNewPositionIndex]);
//
//   return (rankAboveNew: rankAboveNew, rankBelowNew: rankBelowNew);
// }
}
