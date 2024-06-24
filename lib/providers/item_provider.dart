import 'package:flutter/material.dart';
import 'package:item_tracker/models/Item.dart';

class ItemProvider extends ChangeNotifier{
  final List<Item> items = [];

  ItemProvider();

  void addItem(String name, String description) async{
    items.add(Item(name:name,description: description));
    notifyListeners();
  }
  void updateItem(int itemId,String name, String description) async{
    var i = items.indexWhere((e){
      return e.itemId == itemId;
    });
    items[i].name = name;
    items[i].description = description;
    notifyListeners();
  }

  void removeItem(int itemId) async{
    items.removeWhere((e){
      return e.itemId == itemId;
    });
    notifyListeners();
  }
}