// in this page both works are here that is Edit or Update and Delete

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDataPage extends StatefulWidget {
  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      // Agar Ham yaha .get se pahle .orderBy("name") likhege to jo
      // lists hogi wo alphabatical order matlb A to Z aygi .
      var result = await db.collection("Students").get();
      return result;
    } catch (e) {
      print(e.toString());
    }
  }

  String? updatedname;
  String? updatedemail;

  updateData(id, updatedname, updatedemail) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db.collection("Students").doc(id).update({
        "name": updatedname,
        "email": updatedemail,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  deleteData(id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      await db.collection("Students").doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Update Data Page",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, dynamic snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final database = snapshot.data.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 20,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Alert"),
                                        elevation: 20,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    updatedname = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  labelText: "Enter Name",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    updatedemail = value;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  labelText: "Enter Email",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              updateData(
                                                  database.id,
                                                  updatedname.toString(),
                                                  updatedemail.toString());
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Edit"),
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.black,
                              ),
                            ),
                            title: Text("${database["name"]}"),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${database.id}"),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                  Text("${database["email"]}"),
                                ],
                              ),
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete Items"),
                                          elevation: 20,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                updateData(
                                                    database.id,
                                                    updatedname.toString(),
                                                    updatedemail.toString());
                                                setState(() {});
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Delete"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
