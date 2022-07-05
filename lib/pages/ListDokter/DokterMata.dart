import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/ListDokter/read_data/DoctorTile.dart';

class ListDokterMata extends StatefulWidget {
  const ListDokterMata({Key? key}) : super(key: key);

  @override
  State<ListDokterMata> createState() => _ListDokterMataState();
}

class _ListDokterMataState extends State<ListDokterMata> {
  // Document IDs
  List<String> docIDs = [];

  // Get docIDs by Category
  Future getDocIDs() async {
    await FirebaseFirestore.instance
        .collection('doctors')
        .where('spesialis', isEqualTo: "Mata")
        .get()
        .then((event) {
      for (var doc in event.docs) {
        docIDs.add(doc.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dokter Mata"),
        centerTitle: true,
      ),
      backgroundColor: secondaryColor,
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
                              child: DoctorTile(documentID: docIDs[index]));
                        });
                  })),
        ],
      ),
    );
  }
}
