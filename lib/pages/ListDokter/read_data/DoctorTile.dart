import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/components/utils/reuse_widgets.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/DokterDetail.dart';
import 'package:kliniku/pages/ListDokter/model/DokterModel.dart';

class DoctorTile extends StatefulWidget {
  final String documentID;
  const DoctorTile({Key? key, required this.documentID}) : super(key: key);

  @override
  State<DoctorTile> createState() => _DoctorTileState();
}

class _DoctorTileState extends State<DoctorTile> {
  CollectionReference doctors =
      FirebaseFirestore.instance.collection('doctors');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: doctors.doc(widget.documentID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 40, minWidth: 40, maxHeight: 55, maxWidth: 55),
                child: imagePath("doctor.jpg"),
              ),
              title: Text("${data['nama']} [${data['spesialis']}]",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat")),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${data['jamKerja']}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Nunito'),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              ),
              tileColor: primaryColor,
              onTap: () {
                _navigateDetail(context, data);
              },
            );
          }
          return Text("Loading ..");
        });
  }

  void _navigateDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DokterDetail(
                  dokterMd: DokterModel(
                    nama: data['nama'],
                    spesialis: data['spesialis'],
                    deskripsi: data['deskripsi'],
                    jamKerja: data['jamKerja'],
                    hariKerja: data['hariKerja'],
                    noHp: data['noHp'],
                    noDokter: data['noDokter'],
                  ),
                )));
  }
}
