import 'package:flutter/material.dart';
import 'package:my_karaoke/models/shopping_list.dart';
import 'package:my_karaoke/screens/event_screen.dart';
import 'package:my_karaoke/ui/items_screen.dart';
import 'package:my_karaoke/ui/shopping_list_dialog.dart';
import 'package:my_karaoke/util/dbhelper.dart';

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList>? shoppingList;
  ShoppingListDialog? dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  Widget build(BuildContext context) {
    ShoppingListDialog dialog = ShoppingListDialog();
    showData();
    return Scaffold(
      body: ListView.builder(
          itemCount: (shoppingList != null) ? shoppingList!.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(shoppingList![index].name),
                onDismissed: (direction) {
                  String strName = shoppingList![index].name;
                  helper.deleteList(shoppingList![index]);
                  setState(() {
                    shoppingList!.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$strName deleted")));
                },
                child: ListTile(
                  title: Text(shoppingList![index].name),
                  leading: CircleAvatar(
                    child: Text(shoppingList![index].priority.toString()),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog.buildDialog(
                              context, shoppingList![index], false));
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ItemsScreen(shoppingList![index])),
                    );
                  },
                ));
          }),
      floatingActionButton: (EventScreen.selectedIndex == 1)
          ? FloatingActionButton.extended(
              label: Column(
                children: [
                  Icon(Icons.add),
                  Text("Add"),
                ],
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      dialog.buildDialog(context, ShoppingList(0, '', 0), true),
                );
              },
              backgroundColor: Colors.pink,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}
