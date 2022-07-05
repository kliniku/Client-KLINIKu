import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/components/utils/reuse_widgets.dart';
import 'package:kliniku/const.dart';

class StatusTile extends StatefulWidget {
  final String documentID;
  const StatusTile({Key? key, required this.documentID}) : super(key: key);

  @override
  State<StatusTile> createState() => _StatusTileState();
}

class _StatusTileState extends State<StatusTile> {
  DateTime _dateTime = DateTime.now();
  CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');

  Future updateDateAppointment(DateTime newDate, String pasienEmail) async {
    try {
      await appointments
          .where("email", isEqualTo: pasienEmail)
          .get()
          .then((event) {
        for (var doc in event.docs) {
          appointments
              .doc(doc.id)
              .update({'tglJanji': newDate.toString().split(' ')[0]});
        }
      });
      showDialog(
          context: context,
          builder: (context) {
            return successBox(context, "Berhasil diperbarui");
          });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: appointments.doc(widget.documentID).get(),
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
                title: Text("${data['namaDokter']} [${data['spesialis']}]",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "Montserrat")),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "${data['tglJanji']} ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Nunito'),
                    ),
                    Container(
                      width: 80,
                      color:
                          data['status'] == true ? Colors.green : Colors.yellow,
                      child: Center(
                        child: Text(
                          data['status'] == true ? "ACC" : "PENDING",
                          style: TextStyle(
                              color: data['status'] == true
                                  ? Colors.white
                                  : Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'),
                        ),
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                    onPressed: () {
                      print("press");
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                color: secondaryColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Detail Status Janji",
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Nunito'),
                                    ),
                                    SizedBox(height: 20),
                                    //

                                    Text("Nama Pasien : ${data['namaLengkap']}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito')),
                                    Text(
                                        "Nama Dokter : ${data['namaDokter']} [${data['spesialis']}]",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito')),
                                    Text("Tanggal Janji : ${data['tglJanji']}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito')),
                                    Text(
                                        "Jam Operasional : ${data['jamOperasional']}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito')),
                                    Text("Status : ${data['statusDesc']}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito')),
                                    SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Kembali",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Nunito',
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _selectDate(
                                                  context, data['email']);
                                            },
                                            child: Text(
                                              "Edit Tanggal",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'Nunito',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ]),
                                  ],
                                ));
                          });
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                tileColor: (data['statusDesc'] == "Canceled")
                    ? Colors.red
                    : brightColor);
          }
          return Text("Loading ..");
        });
  }

  Future<void> _selectDate(BuildContext context, String email) async {
    DateTime? _newDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1800),
        lastDate: DateTime(3000));
    if (_newDate != null) {
      setState(() {
        _dateTime = _newDate;
        updateDateAppointment(_dateTime, email);
      });
    }
    return;
  }
}
