import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/pages/auth/model/user_model.dart';
import 'package:kliniku/pages/components/home_menu.dart';
import 'package:kliniku/pages/components/location_menu.dart';
import 'package:kliniku/pages/components/profile_page.dart';
import 'package:kliniku/pages/components/status_menu.dart';

class MenuPasien extends StatefulWidget {
  const MenuPasien({Key? key}) : super(key: key);

  @override
  State<MenuPasien> createState() => _MenuPasienState();
}

class _MenuPasienState extends State<MenuPasien> {
  int index = 0;
  final screens = [HomePage(), StatusPage(), LocationPage()];
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  UserModel authUser = UserModel();

  // FCM
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? token = '';

  Future getData() async {
    await db
        .collection("users")
        .where('email', isEqualTo: user!.email)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        // print("${doc.id} => ${doc.data()}");
        this.authUser = UserModel.fromMap(doc.data());
      }
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      print("NEW TOKEN : $value");
      setState(() {
        token = value;
      });
      updateToken(value!);
    });
  }

  void updateToken(String token) async {
    await db
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        db.collection('users').doc(doc.id).update({
          'tokenUser': token,
        });
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadFCM();
    listenFCM();
    getData();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30, color: Colors.white),
      Icon(Icons.library_books, size: 30, color: Colors.white),
      Icon(Icons.location_on_sharp, size: 30, color: Colors.white),
    ];

    return Scaffold(
        appBar: _buildAppBar(context),
        extendBody: true,
        backgroundColor: secondaryColor,
        bottomNavigationBar: _buildCurvedNavbar(items),
        body: screens[index]);
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: secondaryColor,
      elevation: 0,
      title: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text(" ",
                style:
                    TextStyle(color: Colors.black, fontFamily: 'Montserrat'));
          } else {
            return Text("Halo ${authUser.firstName}!",
                style:
                    TextStyle(color: Colors.black, fontFamily: 'Montserrat'));
          }
        },
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        userAuth: authUser,
                      )));
        },
        icon: Icon(
          Icons.account_circle_outlined,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              FirebaseMessaging.instance.deleteToken();
            },
            icon: Icon(Icons.logout_outlined, color: Colors.black))
      ],
    );
  }

  CurvedNavigationBar _buildCurvedNavbar(List<Widget> items) {
    return CurvedNavigationBar(
      color: darkerColor,
      backgroundColor: Colors.transparent,
      items: items,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      height: 55,
      index: index,
      onTap: (index) => setState(() {
        this.index = index;
      }),
    );
  }
}
