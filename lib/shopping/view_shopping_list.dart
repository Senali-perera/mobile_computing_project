import 'package:flutter/material.dart';
import 'package:mobile_computing_project/services/database/shopping_basket_db.dart';
import 'package:mobile_computing_project/shopping/add_shopping_basket.dart';
import 'package:mobile_computing_project/shopping/shopping_basket.dart';
import 'package:mobile_computing_project/shopping/view_shopping_basket.dart';

class ViewShoppingList extends StatefulWidget {
  const ViewShoppingList({super.key});

  @override
  _ShoppingListState createState()=>_ShoppingListState();
}

class _ShoppingListState extends State<ViewShoppingList>{
  List<ShoppingBasket>? _shoppingBaskets = [];
  final shoppingBasketDB = ShoppingBasketDB();

  void loadShoppingBaskets() async {

    List<ShoppingBasket> shoppingBaskets = await shoppingBasketDB.loadAllShoppingBaskets();
    setState(() {
      _shoppingBaskets = shoppingBaskets;
    });
  }

  void _addShoppingBasket(BuildContext context) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddShoppingBasket(),
        ));

    shoppingBasketDB.insertShoppingBasket(result);
    loadShoppingBaskets();
  }

  void _editShoppingBasket(BuildContext context, ShoppingBasket shoppingBasket) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewShoppingBasket(shoppingBasket: shoppingBasket),
        ));

    shoppingBasketDB.updateShoppingBasket(shoppingBasket.id, result);
    loadShoppingBaskets();
  }

  @override
  void initState() {
    super.initState();
    loadShoppingBaskets();
  }

  Widget _viewShoppingBasket(ShoppingBasket shoppingBasket){
    return ListTile(
      title: Text(shoppingBasket.title),
      onTap: (){_editShoppingBasket(context, shoppingBasket);},
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          shoppingBasketDB.deleteShoppingBasket(shoppingBasket.id);
          loadShoppingBaskets();
        },
      ),
      subtitle: Text(shoppingBasket.dateTime!.toString()),
      leading: IconButton(
        icon: Icon(
          shoppingBasket.isDone ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () {
          shoppingBasketDB.deleteShoppingBasket(shoppingBasket.id);
          loadShoppingBaskets();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping List')),
      body: ListView.builder(
        itemCount: _shoppingBaskets?.length,
        itemBuilder: (context, index) {
          return _viewShoppingBasket(_shoppingBaskets![index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          _addShoppingBasket(context);
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}