import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:main_store_app/pages/orders/delivered.dart';
import 'package:main_store_app/pages/orders/neworder.dart';
import 'package:main_store_app/pages/orders/ongoingorder.dart';
import 'package:main_store_app/pages/orders/readyorder.dart';
import 'package:main_store_app/pages/searchPage.dart';
import 'pages/home_page.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/':(context)=>HomePage(),
        '/order/new':(context)=>NewOrder(),
        '/order/ongoing':(context)=>OngoingOrder(),
        '/order/ready':(context)=>ReadyOrder(),
        '/order/deliverd':(context)=>DeliveredOrders(),
        '/search':(context)=>SearchPage()
      },
    );
  }
}
