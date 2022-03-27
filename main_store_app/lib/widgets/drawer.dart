// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: [
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/');
                },
                child: ListTile(
              title: Text("take new order"),   
            )),  
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/order/new');
                },
                child: ListTile(
              title: Text("new orders"),
            )),
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/order/ongoing');
                },
                child: ListTile(
              title: Text("ongoing orders"),
            )),
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/order/ready');
                },
                child: ListTile(
              title: Text("ready order"),
            )),
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/order/deliverd');
                },
                child: ListTile(
              title: Text("delivered order"),
            )),
            InkWell(
                onTap: (){
                  Navigator.of(context).popAndPushNamed('/search');
                },
                child: ListTile(
              title: Text("search order"),
            )),
          ],
        ),
      ),
    );
  }
}
