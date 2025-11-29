import 'package:flutter/material.dart';
import 'package:flutter_projects1/Api_Data/Api_Services/Api_Services.dart';
import 'package:flutter_projects1/Api_Data/Model/Ayah_of_TheDay.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    //  creat apiServices instance
    ApiServices _apiScervices = ApiServices();

    void setData()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("alreadyUsed", true);

    }
    @override
    void initState(){
      super.initState();
    }


    AyahofTheday? data;
    // make responsive
    var size = MediaQuery.of(context).size;
    HijriCalendar.setLocal("ar");
    var _hijri = HijriCalendar.now();
    var day = DateTime.now();
    var formate = DateFormat("EEE , d MMM, yyyy");
    var formatted = formate.format(day);

    _apiScervices.getAyahOfTheDay().then((value) => data = value);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
              BoxShadow(
              color: Colors.grey, // shadow color
          spreadRadius: 2, // how wide the shadow spreads
          blurRadius: 5, // how soft the shadow is
          offset: const Offset(0, -3),
              )
          ],

                image: DecorationImage(
                  image: AssetImage("assets/background_img.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <InlineSpan>[
                        WidgetSpan(
                          style: TextStyle(
                            fontSize: size.height * 0.03,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _hijri.hDay.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        WidgetSpan(
                          style: TextStyle(
                            fontSize: size.height * 0.03,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _hijri.longMonthName.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              _hijri.hYear.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      formatted,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _apiScervices.getAyahOfTheDay(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error loading Ayah'),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('No data available.'),
                          );
                        }
                        final ayah = snapshot.data!;
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const Text(
                                "Quran Ayah of the Day",
                                style: TextStyle(fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(thickness: 0.8),
                              Text(
                                ayah.arText ?? "No Arabic text",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                ayah.enTran ?? "No English translation",
                                style: const TextStyle(color: Colors.black54),
                              ),
                              Text(
                                " Surah Name : ${ayah.surEnName} ",
                              ),
                              Text(
                                " Surah meaning : ${ayah.englishNameTranslation} ",
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ]
      )
      ),
    );
  }
}
