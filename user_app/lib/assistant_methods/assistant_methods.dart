import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:user_app/assistant_methods/cart_item_counter.dart';
import 'package:user_app/global/global.dart';

List<String> separateOrderItemIds(orderId) {
  List<String> separateItemIdsList = [], defaultItemList = [];
  int i = 0;

  defaultItemList = List<String>.from(orderId);

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

List<String> separateItemIds() {
  List<String> separateItemIdsList = [], defaultItemList = [];
  int i = 0;
  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (i; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    separateItemIdsList.add(getItemId);
  }

  return separateItemIdsList;
}

void addItemToCart(String? foodItemId, BuildContext context, int itemCounter) {
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  // foodItemId = 'garbadgevalue';
  tempList!.add("${foodItemId!}:$itemCounter"); //1210259022: 2

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({
    "userCart": tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added Successfully. ");

    sharedPreferences!.setStringList("userCart", tempList);

    //update the page

    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}

List<String> separateOrderItemQuantities(orderId) {
  List<String> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = List<String>.from(orderId);

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNumber.toString());
  }

  return separateItemQuantityList;
}

List<int> separateItemQuantities() {
  List<int> separateItemQuantityList = [];
  List<String> defaultItemList = [];

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for (int i = 1; i < defaultItemList.length; i++) {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quanNumber);
  }

  return separateItemQuantityList;
}

void clearCartNow(context) {
  sharedPreferences!.setStringList("userCart", ['garbageValue']);

  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);
    Provider.of<CartItemCounter>(context, listen: false)
        .displayCartListItemsNumber();
  });
}
