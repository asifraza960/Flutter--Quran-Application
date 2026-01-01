import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  bool alreadyUsed = false;

  void getData()async{
    // Obtain shared preferences.[
    final prefs = await SharedPreferences.getInstance();
    alreadyUsed =  prefs.getBool("alreadyUsed") ?? false;
    // onBoarding screen will show for first time
  }
  User? user =FirebaseAuth.instance.currentUser;

  @override
  void initState() {

    super.initState();
    getData();
    // Timer(Duration(seconds: 3), ()=>Navigator.pushReplacement(context,
    // MaterialPageRoute(builder: (context){
    //   return  alreadyUsed ? MainScreen() : OnBoardingScreen();
    // })
    // ));
    Timer(Duration(seconds: 3),(){
      Get.offNamed("/login");
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(child: Text('Muslim Soul',style: TextStyle(color: Colors.black,fontSize: 30),),),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/islamic.png'),
            ),
          ],
        ),
      ),
    );
  }
}