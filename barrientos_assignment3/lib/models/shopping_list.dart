import 'package:hive/hive.dart';

part 'shopping_list.g.dart';

@HiveType(typeId: 1)
class ShoppingListItem extends HiveObject {
  @HiveField(0)
  late String item;

  @HiveField(1)
  late bool isChecked;

  ShoppingListItem({required this.item, this.isChecked = false});
}
