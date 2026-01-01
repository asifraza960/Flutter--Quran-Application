import 'dart:ui_web';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects1/Screens/Home_Screen/Main_Screen.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/SurahDetails.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/juz_screen.dart';
import 'package:get/get.dart';
import 'Screens/Fire_Base_Screens/Login_Screen.dart';
import 'Screens/Fire_Base_Screens/registeration_screen.dart';
import 'Screens/Spleesh_Screen/Spleesh_Screen.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Islamic Soul',
      theme: ThemeData(
        // This is the theme of your application.
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: SplashScreen(),
      routes: {
        JuzScreen.id:(context) => JuzScreen(),
        Surahdetails.id:(context) => Surahdetails(),
      },
      getPages: [
        GetPage(name: '/',  page: ()=> SplashScreen()),
    GetPage(name: '/login',  page:()=> LoginScreen()),
    GetPage( name: '/register',page: ()=> RegisterScreen()),
    GetPage( name: '/main',page: ()=> MainScreen()),
      ],
    );
  }
}


