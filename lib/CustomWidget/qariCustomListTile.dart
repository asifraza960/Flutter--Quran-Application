
import 'package:flutter/material.dart';
import 'package:flutter_projects1/Api_Data/Model/Qari.dart';

class Qaricustomlisttile extends StatefulWidget {
  final Qari qari;
  final VoidCallback ontap;
  const Qaricustomlisttile({super.key ,required this.ontap , required this.qari});

  @override
  State<Qaricustomlisttile> createState() => _QaricustomlisttileState();
}

class _QaricustomlisttileState extends State<Qaricustomlisttile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Padding(
          padding: EdgeInsets.all(4),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                spreadRadius: 0.0,
                color: Colors.black12,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.qari.name!,textAlign: TextAlign.start,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
