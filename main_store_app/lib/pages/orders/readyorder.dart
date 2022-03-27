import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadyOrder extends StatefulWidget {
  @override
  State<ReadyOrder> createState() => _ReadyOrderState();
}

class _ReadyOrderState extends State<ReadyOrder> {
final statusUpdateController = new TextEditingController();

  Future<String> updateOrder(Map<String, dynamic> data) async {
    try {
      String baseUrl = "https://final-server-opjhx9ifm-ravipcb.vercel.app/updateStatus";
      var response = await http.put(
        Uri.parse(baseUrl),
        body: jsonEncode(data),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (response.statusCode == 200) {
        return "Status updated";
      } else {
        return "SOME ERROR OCCURED";
      }
    } catch (SocketException) {
      // fetching error
      return "SOME ERROR OCCURED";
    }
  }

  Future<List> getPosts() async {
    String baseURL = "https://final-server-opjhx9ifm-ravipcb.vercel.app/readyorder";
    try {
      var response = await http.get(Uri.parse(baseURL));
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

  Future<void> updateState(String id,String status)async{
    int statint = int.parse(status);
        Map<String, dynamic> dataa = {
          "id":id,
          "status": statint
        };

        updateOrder(dataa);
  }

  Future openDialog(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Update Status"),
            content: TextField(
              controller: statusUpdateController,
              autofocus: true,
              keyboardType: TextInputType.number,
              
              decoration:
                  InputDecoration(hintText: "1.new/2.work/3.ready/4.delivered"),
            ),
            actions: [
              TextButton(
                child: Text("submit"),
                onPressed: () async{
                  await updateState(id,statusUpdateController.text);
                  statusUpdateController.text="";
                  Navigator.of(context).popAndPushNamed("/order/deliverd");
                  setState(() {
                  });
                },
              ),
            ],
          ));

  var x = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ready Orders"),
      ),
      body: FutureBuilder<List>(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
                return Center(
                  child: Text("No data to show"),
                );
              }
              var stat = snapshot.data?[0]['status'];
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // leading: Text('Ready'),
                      title: Text(snapshot.data?[index]['clientName']),
                      subtitle: Text(snapshot.data?[index]['productDesc']),
                      trailing: Text(
                          snapshot.data?[index]['updatedAt'].substring(0, 10)),
                      onTap: () {
                        openDialog(snapshot.data?[index]['_id']);
                      },
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
          }),
      drawer: MyDrawer(),
    );
  }
}
