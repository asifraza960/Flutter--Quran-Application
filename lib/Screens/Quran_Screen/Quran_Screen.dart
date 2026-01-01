import 'package:flutter/material.dart';
import 'package:flutter_projects1/Api_Data/Api_Services/Api_Services.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/SurahDetails.dart';
import 'package:flutter_projects1/Screens/Quran_Screen/juz_screen.dart';
import '../../Api_Data/Model/Surah.dart';
import '../../Api_Data/Model/sajda.dart';
import '../../CustomWidget/CustomSutaListTile.dart';
import '../../CustomWidget/sajdaCustomTile.dart'; // fixed name spelling

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  ApiServices apiServices = ApiServices();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Quran",style: TextStyle(
              color: Colors.white
            ),),
            backgroundColor: Constants.kPrimary,
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Text(
                  "Surah",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  "Sajda", // Added missing tab title
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  "Juz",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              FutureBuilder<List<Surah>>(
                future: apiServices.getSurah(),
                builder: (BuildContext context,AsyncSnapshot<List<Surah>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found'));
                  } else {
                    List<Surah> surah = snapshot.data!;
                    return ListView.builder(
                      itemCount: surah.length,
                      itemBuilder: (context, index) => CustomSurahListTile(
                        surah: surah[index],
                        context: context,
                        onTap: () {
                          setState(() {
                            Constants.suraIndex = (index + 1);
                          });
                          Navigator.pushNamed(context, Surahdetails.id);
                        },
                      ),
                    );
                  }
                },
              ),
             
              FutureBuilder(
                future: apiServices.getSajda(),
                builder: (context,AsyncSnapshot<SajdaList> snapshot){
                  if(snapshot.hasError){
                    return Center(child: Text('Something went wrong'),);
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.sajdaAyahs.length,
                    itemBuilder: (context , index) => SajdaCustomTile(snapshot.data!.sajdaAyahs[index], context),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: 30,
                      itemBuilder: (context ,index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              Constants.juzIndex = (index +1);
                            });
                            Navigator.pushNamed(context, JuzScreen.id);
                          },
                          child:  Card(
                            elevation: 4,
                            color: Colors.blueGrey,
                            child: Center(
                              child: Text("${index +1}" ,style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),),
                            ),
                          ),
                        );
                      }
                  ),

                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
