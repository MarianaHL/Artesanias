import 'package:Artesanias/pages/Catalog.dart';
import 'package:Artesanias/pages/Detail.dart';
import 'package:Artesanias/pages/add_producto.dart';
import 'package:Artesanias/pages/splash_screen.dart';
import 'package:flutter/material.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
};

void main() => runApp(new MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.pinkAccent, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes));
