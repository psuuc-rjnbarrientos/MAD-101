import 'package:barrientos_assignment3/models/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyAppHomeScreen extends StatefulWidget {
  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  var item = TextEditingController();

  void addItem() async {
    final box = await Hive.openBox('shoppingList');
    await box.add(ShoppingListItem(item: item.text));
    setState(() {
      item.clear();
    });
  }

  void clearSelectedItem() async {
    final box = await Hive.openBox('shoppingList');
    List<int> keysToDelete = [];
    for (var i = 0; i < box.length; i++) {
      final item = box.getAt(i) as ShoppingListItem;
      if (item.isChecked) {
        keysToDelete.add(i);
      }
    }
    for (var key in keysToDelete.reversed) {
      box.deleteAt(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.check_circle_outline_outlined),
        title: Text('Shopping List'),
        actions: [
          IconButton(
            onPressed: clearSelectedItem,
            icon: Icon(Icons.cleaning_services_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: TextField(
                      controller: item,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Add Item'),
                      ),
                      onSubmitted: (_) {
                        addItem();
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: addItem,
                        child: Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('shoppingList').listenable(),
                builder: (context, Box box, _) {
                  List<ShoppingListItem> shoppingList =
                      box.values.toList().cast<ShoppingListItem>();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: shoppingList.length,
                    itemBuilder: (_, index) {
                      final item = shoppingList[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            item.item,
                            style: TextStyle(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          trailing: Checkbox(
                            value: item.isChecked,
                            onChanged: ((bool? value) {
                              setState(() {
                                item.isChecked = value!;
                                item.save(); // Save changes to Hive
                              });
                            }),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
