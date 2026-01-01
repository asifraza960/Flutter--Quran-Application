
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import 'package:flutter_projects1/Screens/Home_Screen/HomeScreen.dart';
import 'package:flutter_projects1/Screens/Prayer_Screen/Prayer_screen.dart';
import 'package:flutter_projects1/Screens/QariScreen/qariScreen.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/Quran_Screen.dart';
import 'package:flutter_projects1/chat_bot/caht.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override


  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  int selectindex  = 0;
  final List<Widget> _widgetList = [Homescreen(),QuranScreen(),QariScreen(),PrayerScreen(), ChatScreen()];
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetList[selectindex],
        bottomNavigationBar: ConvexAppBar(
          items: [
            TabItem(icon: Image.asset("assets/home.png",color: Constants.kPrimary,), title: 'Home'),
            TabItem(icon: Image.asset("assets/holyQuran.png",color: Constants.kPrimary,), title: 'Quran'),
            TabItem(icon: Image.asset("assets/audio.png",color: Constants.kPrimary,), title: 'Audio'),
            TabItem(icon: Image.asset("assets/mosque.png",color: Constants.kPrimary,), title: 'Prayer'),
            TabItem(icon: Icon(Icons.chat,color: Constants.kPrimary,), title: 'chat'),


          ],
          initialActiveIndex: 0,
          onTap: UpdatedIndex,
            backgroundColor: Constants.kPrimary,
        )
    );
  }
  void UpdatedIndex(index){
    setState(() {
      selectindex = index;
    });
  }
}
