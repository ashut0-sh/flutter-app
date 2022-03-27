// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:main_store_app/pages/orders/neworder.dart';
import '../../widgets/drawer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String baseUrl = "https://final-server-opjhx9ifm-ravipcb.vercel.app/newOrder";

  Future<String> NewOrder(Map<String, dynamic> data) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        return "ORDER SAVED";
      } else {
        return "SOME ERROR OCCURED";
      }
    } catch (SocketException) {
      // fetching error
      return "SOME ERROR OCCURED";
    }
  }

  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final nameEditingController = new TextEditingController();
  final numberEditingController = new TextEditingController();
  final prodDescEditingController = new TextEditingController();
  final statusEditingController = new TextEditingController();
  var saved = "";

  @override
  Widget build(BuildContext context) {
    //first name field
    final nameField = TextFormField(
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Customer Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //customer number field
    final numberField = TextFormField(
        autofocus: false,
        controller: numberEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Number cannot be Empty");
          }
          if (value.length < 10) {
            return ("Invalid Number");
          }
          return null;
        },
        onSaved: (val) {
          numberEditingController.text = val!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Customer Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //prodDesc field
    final prodDescField = TextFormField(
      autofocus: false,
      controller: prodDescEditingController,
      keyboardType: TextInputType.multiline,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please the description");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.description),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Order Description",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: 5,
    );

    //status field
    final statusField = TextFormField(
        autofocus: false,
        controller: statusEditingController,
        keyboardType: TextInputType.number,
        onSaved: (value) {
          statusEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.timeline),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "1.new/2.work/3.ready/4.delivered",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //submit function
    Future<void> submit(
        String name, String contact, String description, String status) async {
      if (_formKey.currentState!.validate()) {
        int numint = int.parse(contact);
        int statint = int.parse(status);
        Map<String, dynamic> dataa = {
          "name": name,
          "number": numint,
          "desc": description,
          "status": statint
        };

        var res = await NewOrder(dataa);

        // setState(() {
        //   saved = res;
        // });
      } else {
        print("error");
      }
    }

    final confirmation = Material(
      child: Center(
        child: Container(
          child: Text('${saved}'),
        ),
      ),
    );

    //submit button
    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            submit(nameEditingController.text, numberEditingController.text,
                prodDescEditingController.text, statusEditingController.text);
            Future.delayed(const Duration(milliseconds: 1000), (){
              Navigator.of(context).popAndPushNamed('/order/new');
            });
          },
          child: Text(
            "Place Order",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Place New Order"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //     height: 180,
                    //     child: Image.asset(
                    //       "assets/logo.png",
                    //       fit: BoxFit.contain,
                    //     )),
                    SizedBox(height: 20),
                    nameField,
                    SizedBox(height: 20),
                    numberField,
                    SizedBox(height: 20),
                    prodDescField,
                    SizedBox(height: 20),
                    statusField,
                    SizedBox(height: 20),
                    // confirmPasswordField,
                    // SizedBox(height: 20),
                    submitButton,
                    SizedBox(height: 15),
                    confirmation,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
