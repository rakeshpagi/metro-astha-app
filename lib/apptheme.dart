import 'package:flutter/material.dart';

var apptheme=ThemeData(
    primarySwatch: Colors.purple,
    primaryColorDark: Color(0xff512DA8),
    primaryColor: Color(0xff673AB7),
    primaryColorLight: Color(0xffD1C4E9),
    accentColor: Color(0xffFF4081),    
    brightness: Brightness.light,    
    buttonTheme: ButtonThemeData(buttonColor: Color(0xffFF4081),textTheme: ButtonTextTheme.primary ),    
    
     buttonColor:  Color(0xffFF4081)
);

var appthemedark=ThemeData.dark().copyWith(
  
    primaryColorDark: Color(0xff512DA8),
    primaryColor: Color(0xff673AB7),
    primaryColorLight: Color(0xffD1C4E9),
    accentColor: Color(0xffFF4081),        
    brightness: Brightness.dark,
    
    buttonTheme: ButtonThemeData(buttonColor: Colors.red,padding: EdgeInsets.all(8) ,
      textTheme: ButtonTextTheme.accent,height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
     ),    
  
      focusColor:  Color(0xffFF4081),
     buttonColor:  Color(0xffFF4081),
     
);