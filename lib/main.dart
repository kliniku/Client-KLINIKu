import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kliniku/components/screens/onboarding.dart';
import 'package:kliniku/const.dart';
import 'package:kliniku/firebase_options.dart';
import 'package:kliniku/main_page.dart';
import 'package:kliniku/pages/ListDokter/DokterGigi.dart';
import 'package:kliniku/pages/ListDokter/DokterIbuAnak.dart';
import 'package:kliniku/pages/ListDokter/DokterLansia.dart';
import 'package:kliniku/pages/ListDokter/DokterMata.dart';
import 'package:kliniku/pages/ListDokter/DokterTHT.dart';
import 'package:kliniku/pages/ListDokter/DokterUmum.dart';
import 'package:kliniku/pages/components/home_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onBoard');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KLINIKu',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(primary: primaryColor)),
      home: isViewed != 0 ? OnBoard() : MainPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/umum': (context) => ListDokterUmum(),
        '/mata': (context) => ListDokterMata(),
        '/gigi': (context) => ListDokterGigi(),
        '/tht': (context) => ListDokterTHT(),
        '/lansia': (context) => ListDokterLansia(),
        '/ibu_anak': (context) => ListDokterIbuAnak(),
      },
      // home: MainPage(),
    );
  }
}
