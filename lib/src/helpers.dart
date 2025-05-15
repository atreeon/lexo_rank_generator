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

  /// If we move multiple items
  /// We take the first item to be moved and then move all our items above that one
  List<T> moveItems(
      List<T> list,
      List<T> items,
      MoveDirection direction,
      ) {
    final lexo = const LexoRank();
    var itemId = getId(items.first);
    var index = list.indexWhere((x) => getId(x) == itemId);

    var aboveNewPositionIndex = index + (direction == MoveDirection.up ? -2 : 1);
    var belowNewPositionIndex = index + (direction == MoveDirection.up ? -1 : 2);

    var rankAboveNew = getRankStr(list[aboveNewPositionIndex]);
    var rankBelowNew = getRankStr(list[belowNewPositionIndex]);

    var newId = lexo.getRankBetween(firstRank: rankAboveNew, secondRank: rankBelowNew);

    var newItem = setRankStr(item, newId);

    return newItem;
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
