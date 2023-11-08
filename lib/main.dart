import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pesquisa_cep/views/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';


void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, //Barra do Debug
    home: HomePage(),
    builder: FToastBuilder(),
    theme: ThemeData(brightness: Brightness.light, primarySwatch: Colors.amber, fontFamily: 'Poppins'),
    darkTheme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.lightBlue, fontFamily: 'Poppins'),
  ));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
      return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}