import 'package:flutter/material.dart';


String ils = '₪';
Color white =  Color.fromRGBO(237, 242, 243, 1);
Color primary = Colors.black;
Color secondary = 1 == 1
    ? Color.fromARGB(255, 240, 193, 98)
    : Color.fromARGB(255, 240, 65, 170);

String storeName =
    1 == 1 ? "LECKER - More Than Just Ice cream" : "Black Store Tel Aviv";

String storeTitle = "Black Store";
Map<String, Map<String, dynamic>> data = {
  "Black Store": {
    'primary': primary,
    'secondary': Color.fromARGB(255, 240, 65, 170),
    'storeName': "Black Store Tel Aviv",
  },
  "LECKER": {
    'primary': primary,
    'secondary': Color.fromARGB(255, 240, 193, 98),
    'storeName': "LECKER - More Than Just Ice cream",
  },
  "Fluffy": {
    'primary': Color.fromARGB(255, 240, 65, 170),//  Color.fromRGBO(220, 233, 234, 1), ///  Colors.black87,
    'secondary':Colors.black87,
    'storeName': "Fluffy",
  }
};

Future<void> initContants() async {
  storeTitle = 1 == 1 ? "Fluffy" : 'Black Store';
  //
  
  primary = data[storeTitle]!['primary'];
  secondary = data[storeTitle]!['secondary'];
  storeName = data[storeTitle]!['storeName'];
}
