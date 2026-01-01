import 'package:flutter/material.dart';
import 'package:flutter_projects1/Api_Data/Api_Services/Api_Services.dart';
import 'package:flutter_projects1/Constant/Constant.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import '../../Api_Data/Model/Surah_translation.dart';
import '../../CustomWidget/TanslationTile.dart';
import '../../CustomWidget/country_name.dart';
import '../../CustomWidget/translation_enum.dart';

class Surahdetails extends StatefulWidget {
  Surahdetails({super.key});
  static const String id = 'surahDetails_screen';

  @override
  State<Surahdetails> createState() => _SurahdetailsState();
}

class _SurahdetailsState extends State<Surahdetails> {
  final _apiServices = ApiServices();
  // SolidController solidController  = SolidController();
  Translation? _translation = Translation.urdu;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _apiServices.getTranslation(
            Constants.suraIndex ?? 1,
            _translation!.index,
          ),
          builder: (BuildContext context, AsyncSnapshot<SuraTranslationList> snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  itemCount: snapshot.data!.translationlist.length,
                  itemBuilder: (context, index) {
                    return TranslationTile(
                      index: index,
                      surahTranslation: snapshot.data!.translationlist[index],
                    );
                  },
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),

        bottomSheet: SolidBottomSheet(
          headerBar: SizedBox(
            width: MediaQuery.of(context).size.width, // full screen width
            child: Container(
              height: 30,
              color: Constants.kPrimary,
              alignment: Alignment.center,
              child: Text(
                "Swap me",
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child:Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: translationNames.entries.map((item) {
                    return ChoiceChip(
                      label: Text(item.value),
                      selected: _translation == item.key,
                      onSelected: (selected) {
                        setState(() {
                          _translation = item.key;
                        });
                      },
                    );
                  }).toList(),
                )


              ),
            ),
          ),
        ),

      )
    );
  }
}



