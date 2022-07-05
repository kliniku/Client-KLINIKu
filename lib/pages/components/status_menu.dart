import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/components/statusTile.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<String> docIDs = [];
  User? authUser = FirebaseAuth.instance.currentUser;

  // get docIDs by appointments
  Future getDocIDs() async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .where('email', isEqualTo: authUser!.email)
        .get()
        .then((event) {
      event.docs.forEach((element) {
        docIDs.add(element.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: Text("Status Jadwal Anda",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 20)),
        centerTitle: true,
        backgroundColor: darkerColor,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: getDocIDs(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StatusTile(documentID: docIDs[index]));
                        });
                  }))
        ],
      ),
    );
  }
}
