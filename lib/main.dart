import 'package:flutter/material.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/SurahDetails.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/juz_screen.dart';

import 'Screens/Spleesh_Screen/Spleesh_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Islamic Soul',
      theme: ThemeData(
        // This is the theme of your application.
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: SpleeshScreen(),
      routes: {
        JuzScreen.id:(context) => JuzScreen(),
        Surahdetails.id:(context) => Surahdetails(),

      },
    );
  }
}


