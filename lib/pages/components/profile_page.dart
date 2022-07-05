import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniku/components/utils/reuse_widgets.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/auth/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userAuth;
  const ProfilePage({Key? key, required this.userAuth}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller
  final _firstNameController = new TextEditingController();
  final _secondNameController = new TextEditingController();
  final _addrController = new TextEditingController();
  final _phoneNumController = new TextEditingController();
  final _emailController = new TextEditingController();

  final auth = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance.collection('users');

  Future updateUser(
      String firstName, String lastName, String addr, String phoneNum) async {
    try {
      await db.where('email', isEqualTo: auth.email).get().then((event) {
        for (var doc in event.docs) {
          db.doc(doc.id).update({
            'firstName': firstName,
            'lastName': lastName,
            'address': addr,
            'phoneNum': phoneNum,
          });
        }
      });
      showDialog(
          context: context,
          builder: (context) {
            return successBox(context, "Berhasil diperbarui");
          });
      setState(() {
        widget.userAuth.firstName = firstName;
        widget.userAuth.lastName = lastName;
        widget.userAuth.address = addr;
        widget.userAuth.phoneNum = phoneNum;
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            switch (e.code) {
              case "email-already-in-use":
                return alertBox(context, "Email sudah dipakai");
              default:
                return alertBox(context, "Terdapat kesalahan");
            }
          });
    }
  }

  checkNullfirstName(_firstNameController) {
    if (_firstNameController == '') {
      return widget.userAuth.firstName;
    } else {
      return _firstNameController.text.trim();
    }
  }

  checkNulllastName(_secondNameController) {
    if (_secondNameController == '') {
      return widget.userAuth.lastName;
    } else {
      return _secondNameController.text.trim();
    }
  }

  checkNullAddr(_addrNameController) {
    if (_addrNameController == '') {
      return widget.userAuth.address;
    } else {
      return _addrNameController.text.trim();
    }
  }

  checkNullphoneNum(_phoneNumNameController) {
    if (_phoneNumNameController == '') {
      return widget.userAuth.phoneNum;
    } else {
      return _phoneNumNameController.text.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, widget.userAuth);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  if (_firstNameController.text.trim() == '' ||
                      _secondNameController.text.trim() == '' ||
                      _addrController.text.trim() == '' ||
                      _phoneNumController.text.trim() == '') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return alertBox(context, "Data Kosong");
                        });
                  } else {
                    updateUser(
                        checkNullfirstName(_firstNameController),
                        checkNulllastName(_secondNameController),
                        checkNullAddr(_addrController),
                        checkNullphoneNum(_phoneNumController));
                  }
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 18, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              defaultPicProfile(),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Text(
                "${widget.userAuth.firstName} ${widget.userAuth.lastName}",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
              SizedBox(
                height: 25,
              ),
              _textField("Nama Depan", "${widget.userAuth.firstName}",
                  _firstNameController, false),
              _textField("Nama Belakang", "${widget.userAuth.lastName}",
                  _secondNameController, false),
              _textField("Alamat", "${widget.userAuth.address}",
                  _addrController, false),
              _textField("No Handphone", "${widget.userAuth.phoneNum}",
                  _phoneNumController, false),
              _textField(
                  "Email", "${widget.userAuth.email}", _emailController, true),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _textField(String labelText, String placeholder,
    TextEditingController controller, bool isRead) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: TextField(
      readOnly: isRead,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          labelStyle: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
              fontSize: 16, fontFamily: 'Montserrat', color: Colors.black)),
    ),
  );
}

Center defaultPicProfile() {
  return Center(
    child: Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.1),
                    offset: Offset(0, 10))
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"))),
        )
      ],
    ),
  );
}
