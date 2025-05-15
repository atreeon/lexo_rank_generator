import 'package:dartx/dartx.dart';
import 'package:lexo_rank_generator/lexo_rank_generator.dart';

enum MoveDirection { up, down }

class LexoRankListHelper<T, TId> {
  final TId Function(T) getId;
  final String Function(T) getRankStr;
  final T Function(T, String) setRankStr;

  LexoRankListHelper({required this.getId, required this.getRankStr, required this.setRankStr});

  List<T> moveItemInList(List<T> list, T item, MoveDirection moveDirection) {
    var newItem = moveItem(list, item, MoveDirection.up);
    var updatedList = list.map((x) => getId(x) == getId(newItem) ? newItem : x).sortedBy((x) => getRankStr(x)).toList();
    return updatedList;
  }

  List<T> moveItemsInList(List<T> list, List<T> itemsToMove, MoveDirection moveDirection) {
    var newItems = moveItems(list, itemsToMove, moveDirection);

    var updatedList = list //
        .map((x) => newItems.firstOrNullWhere((y) => getId(x) == getId(y)) != null ? newItems.firstWhere((y) => getId(x) == getId(y)) : x)
        .sortedBy((x) => getRankStr(x))
        .toList();
    return updatedList;
  }

  /// If we move multiple items
  /// We take the first item to be moved and then move all our items above that one
  List<T> moveItems(
    List<T> list,
    List<T> itemsToMove,
    MoveDirection direction,
  ) {
    var rankLength = 12;

    if (list.isEmpty) {
      throw LexoRankException('Minimum of 1 item required');
    }

    final lexo = const LexoRank();
    // var itemId = getId(itemsToMove.first);

    var itemId = direction == MoveDirection.up ? getId(itemsToMove.first) : getId(itemsToMove.last);

    var index = list.indexWhere((x) => getId(x) == itemId);

    var aboveNewPositionIndex = index + (direction == MoveDirection.up ? -2 : 1);
    var belowNewPositionIndex = index + (direction == MoveDirection.up ? -1 : 2);

    var rankAboveNew = aboveNewPositionIndex < 0 //
        ? List.generate(rankLength, (_) => 'a').join()
        : getRankStr(list[aboveNewPositionIndex]);

    var rankBelowNew = belowNewPositionIndex >= list.length //
        ? List.generate(rankLength, (_) => 'z').join()
        : getRankStr(list[belowNewPositionIndex]);

    if (list.length == 1) {
      var newId = lexo.getRankBetween(firstRank: rankAboveNew, secondRank: rankBelowNew);
      var newItem = setRankStr(itemsToMove.first, newId);
      return [newItem];
    } else {
      var ranks = lexo.generateInitialRank(
        sizeOfItems: itemsToMove.length + 2,
        rankLength: rankLength,
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
}

// //move down
// T moveUpInListSingleItem<T, TId>(List<T> list,
//     T item,
//     TId Function(T) getId,
//     String Function(T) getRankStr,
//     T Function(String) setRankStr,) {}

//move multiple

//move up in list single item (only return the item that has moved)
// T moveUpInListSingleItem<T, TId>(
//   List<T> list,
//   T item,
//   TId Function(T) getId,
//   String Function(T) getRankStr,
//   T Function(String) setRankStr,
// ) {
//   final lexo = const LexoRank();
//   var itemId = getId(item);
//   var index = list.indexWhere((x) => getId(x) == itemId);
//
//   var rankAboveNew = getRankStr(list[index - 2]);
//   var rankBelowNew = getRankStr(list[index - 1]);
//
//   var newId = lexo.getRankBetween(firstRank: rankAboveNew, secondRank: rankBelowNew);
//
//   var newItem = setRankStr(newId);
//
//   return newItem;
// }
