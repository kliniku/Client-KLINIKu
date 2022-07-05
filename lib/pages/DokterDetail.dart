import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/ListDokter/model/DokterModel.dart';
import 'package:kliniku/pages/auth/model/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DokterDetail extends StatefulWidget {
  final DokterModel dokterMd;
  const DokterDetail({Key? key, required this.dokterMd}) : super(key: key);

  @override
  State<DokterDetail> createState() => _DokterDetailState();
}

class _DokterDetailState extends State<DokterDetail> {
  DateTime _dateTime = DateTime.now();
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  UserModel authUser = UserModel();

  void getDataUser() async {
    await db
        .collection("users")
        .where('email', isEqualTo: user!.email)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
        this.authUser = UserModel.fromMap(doc.data());
      }
    });
  }

  Future createAppointment(DateTime DateAppointment) async {
    try {
      String fullName = '${authUser.firstName} ${authUser.lastName}';
      await db.collection('appointments').add({
        'namaLengkap': fullName,
        'email': authUser.email, // Buat ambil email dari user yang login
        'noHp': authUser.phoneNum,
        'namaDokter': widget.dokterMd.nama,
        'spesialis': widget.dokterMd.spesialis,
        'jamOperasional': widget.dokterMd.jamKerja,
        'tglJanji': DateAppointment.toString().split(' ')[0],
        'status': false, // True = sudah dijanjikan, False = belum dijanjikan
        'statusDesc': 'pending' // Pending, Confirmed, Canceled
      });
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  @override
  void initState() {
    getDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          gambarDokter(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    offset: Offset(0, -4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: rowNama(widget: widget),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 30,
                      right: 30,
                    ),
                    child: spesialisDokter(widget: widget),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 30,
                      right: 30,
                    ),
                    child: deskripsiDokter(widget: widget),
                  ),
                  Spacer(),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                child: Text(
                                  'Pilih Tanggal Janji'
                                      .toUpperCase(), // Buat Janji
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? _newDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1800),
        lastDate: DateTime(3000));
    if (_newDate != null) {
      setState(() {
        _dateTime = _newDate;
        // Pilih Tanggal Janji lalu assign ke firestore appointment
        showDialogStatus(context, _newDate);
      });
    }
    return;
  }

  void showDialogStatus(BuildContext context, DateTime DateAppointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Berhasil dibuat"),
              Text("Dengan Tanggal Janji "),
              // text dateappointment to string without time
              Text(
                DateAppointment.toString().split(' ')[0],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("OK"),
              onPressed: () {
                createAppointment(DateAppointment);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class deskripsiDokter extends StatelessWidget {
  const deskripsiDokter({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DokterDetail widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "${widget.dokterMd.deskripsi}",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class spesialisDokter extends StatelessWidget {
  const spesialisDokter({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DokterDetail widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Spesialis ${widget.dokterMd.spesialis}",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}

class rowNama extends StatelessWidget {
  const rowNama({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final DokterDetail widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${widget.dokterMd.nama}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Uri uri = Uri(
              scheme: 'https',
              host: 'api.whatsapp.com',
              path: '/send',
              queryParameters: {
                'phone': '${widget.dokterMd.noHp}',
                'text':
                    'Halo, saya ingin berkonsultasi dengan dokter ${widget.dokterMd.nama}',
              },
            );
            _launchInBrowser(uri);
          }, // WA
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.whatsapp,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 15),
        InkWell(
          onTap: () =>
              launchUrlString("tel:${widget.dokterMd.noHp}"), //direct tlp
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.call_rounded,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

class gambarDokter extends StatelessWidget {
  const gambarDokter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 2 / 3,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/doctor.jpg'),
              fit: BoxFit.cover)),
    );
  }
}
