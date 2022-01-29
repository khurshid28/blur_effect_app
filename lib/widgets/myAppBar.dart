import 'package:flutter/material.dart';

class MyAppBar{
  static PreferredSizeWidget build()=>AppBar(
      leading: Container(),
      backgroundColor:Colors.black,
      centerTitle: true,
      title:const Text("Blur Effect App",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,shadows: [Shadow(color: Colors.white,offset: Offset(1, 1),blurRadius: 1)]),),
    );
}