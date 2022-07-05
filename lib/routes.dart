import 'package:flutter/material.dart';
import 'package:kliniku/main.dart';
import 'package:kliniku/pages/ListDokter/DokterGigi.dart';
import 'package:kliniku/pages/ListDokter/DokterIbuAnak.dart';
import 'package:kliniku/pages/ListDokter/DokterLansia.dart';
import 'package:kliniku/pages/ListDokter/DokterMata.dart';
import 'package:kliniku/pages/ListDokter/DokterTHT.dart';
import 'package:kliniku/pages/ListDokter/DokterUmum.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MyApp());
      case '/umum':
        return MaterialPageRoute(builder: (_) => ListDokterUmum());
      case '/mata':
        return MaterialPageRoute(builder: (_) => ListDokterMata());
      case '/gigi':
        return MaterialPageRoute(builder: (_) => ListDokterGigi());
      case '/tht':
        return MaterialPageRoute(builder: (_) => ListDokterTHT());
      case '/lansia':
        return MaterialPageRoute(builder: (_) => ListDokterLansia());
      case '/ibu_anak':
        return MaterialPageRoute(builder: (_) => ListDokterIbuAnak());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text('Error page')),
      );
    });
  }
}
