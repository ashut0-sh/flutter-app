import 'dart:convert';
// import 'dart:js';
// import 'dart:js';
import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final numberEditingController = new TextEditingController();

  Future<List> getPosts(String number) async {
    String baseURL = "https://final-server-opjhx9ifm-ravipcb.vercel.app/search";
    int num = int.parse(number);
    Map<String, dynamic> data = {"number": num};
    try {
      var response = await http.post(
        Uri.parse(baseURL),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // server error
        return Future.error("Server Error !");
      }
    } catch (SocketException) {
      return Future.error("Error Fetching Data !");
    }
  }

  var submit = 0;
  @override
  Widget build(BuildContext context) {
    final numberField = Padding(
        padding: EdgeInsets.all(8),
        child: TextFormField(
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
              prefixIcon: Icon(Icons.account_circle),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Customer Number",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )));

    final submitButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: 50,
          onPressed: () {
            setState(() {
              submit = 1;
            });
          },
          child: Text(
            "Search",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    var orderList;

    if (submit == 0) {
      orderList = Text("Enter the Number");
    }
    if (submit == 1) {
      orderList = FutureBuilder<List>(
          future: getPosts(numberEditingController.text),
        
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
                return Center(
                  child: Text("No data to show"),
                );
              }
              var stat = snapshot.data?[0]['status'];
              var status;
              if(stat==1){
                status="New";
              }
              if(stat==2){
                status="Working";
              }
              if(stat==3){
                status="Ready";
              }
              if(stat==4){
                status="Delivered";
              }
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text('${status}'),
                      title: Text(snapshot.data?[index]['clientName']),
                      subtitle: Text(snapshot.data?[index]['productDesc']),
                      trailing: Text(
                          snapshot.data?[index]['createdAt'].substring(0, 10)),
                      
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("app"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              numberField,
              submitButton,
              Divider(),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 200,
                child: orderList,
              )
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
