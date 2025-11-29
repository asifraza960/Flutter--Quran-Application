import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects1/Api_Data/Model/Ayah_of_TheDay.dart';
import 'package:flutter_projects1/Api_Data/Model/Qari.dart';
import 'package:flutter_projects1/Api_Data/Model/juz.dart';
import 'package:http/http.dart' as http;
import '../Model/Surah.dart';
import '../Model/Surah_translation.dart';

class ApiServices {
  final endpointUrl = "http://api.alquran.cloud/v1/surah";
  List<Surah> list = [];


  //  get aya of any Surah rendom  and desplay on the  home screen
  Future<AyahofTheday> getAyahOfTheDay() async {
    String Url =
        "http://api.alquran.cloud/v1/ayah/${random(
        1, 6237)}/editions/quran-uthmani,en.asad,en.pickthall ";
    final response = await http.get(Uri.parse(Url));
    if (response.statusCode == 200) {
      return AyahofTheday.fromJSON(json.decode(response.body));
    } else {
      print("Failed to load");
      throw Exception("Failed to load post ");
    }
  }
  Future<SuraTranslationList> getTranslation(int index, int translationIndex) async {

    List<String> translations = [
      "urdu_junagarhi",
      "hindi_omari",
      "english_saheeh",
      "french_rashid",
      "spanish_montada_eu",
      "german_bubenheim",
      "turkish_rwwad",
      "tagalog_rwwad",
      "chinese_suliman",
      "japanese_saeedsato"
    ];

    String lan = translations[translationIndex];

    final url =
        "https://quranenc.com/api/v1/translation/sura/$lan/$index";

    print("CALLING → $url");

    var res = await http.get(Uri.parse(url));

    return SuraTranslationList.fromJson(json.decode(res.body));
  }



  //  get Surah from Api
  Future<List<Surah>> getSurah() async {
    List<Surah> list = []; // Always start with an empty list
    final res = await http.get(Uri.parse(endpointUrl));
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);
      json['data'].forEach((element) {
        list.add(Surah.fromJson(element));
      });
      print("Total Sura Loaded: ${list.length}");
      return list; // ✅ Return after processing
    } else {
      print("Cannot get the Surah, status code: ${res.statusCode}");
      return []; // ✅ Always return something
    }
  }



  //  get juzzz from APi
  Future<JuzModel> getJuzz(int index) async {
    String url = "http://api.alquran.cloud/v1/juz/$index/quran-uthmani";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return JuzModel.fromJson(jsonDecode(response.body));
    } else {
      print("Cannot get the juz, status code: ${response.statusCode}");
      throw Exception('Failed to load...');
    }
  }


  // Qari list Api
  Future<List<Qari>> getQariList() async {
    final url = "https://api.allorigins.win/raw?url=https://www.quranicaudio.com/api/qaris";
    ;  // ✔ www mandatory
    try {
      final res = await http.get(Uri.parse(url));

      print("STATUS CODE → ${res.statusCode}");
      print("BODY → ${res.body}");

      if (res.statusCode != 200) {
        print("API ERROR → ${res.statusCode}");
        throw Exception("Failed to load qari list");
      }

      List data = jsonDecode(res.body);
      print("PARSED LENGTH → ${data.length}");

      List<Qari> qariList = data.map((e) => Qari.fromjson(e)).take(20).toList();

      qariList.sort((a, b) => a.name!.compareTo(b.name!));

      return qariList;
    } catch (e) {
      print("EXCEPTION CAUGHT → $e");
      rethrow;
    }
  }
}







  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }
