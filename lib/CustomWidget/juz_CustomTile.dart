import 'package:flutter/material.dart';
import 'package:flutter_projects1/Api_Data/Model/juz.dart';

class JuzCustomtile extends StatelessWidget {
  final List<JuzAyahs> list;
  final int index;
  const JuzCustomtile({required this.list , required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(list[index].ayahNumber.toString()),
          Text(list[index].ayahsText ,style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),textAlign : TextAlign.end),
          Text(list[index].surahName,
              textAlign : TextAlign.end
          ),
        ],
      ),
    );
  }
}
