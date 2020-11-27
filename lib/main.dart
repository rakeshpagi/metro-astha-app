import 'package:flutter/material.dart';
import 'package:metro_astha/apptheme.dart';
import 'package:metro_astha/models/user.dart';
import 'package:metro_astha/session.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized(); 
    var dbpath=await getDatabasesPath() ; 
    var dbstore=join(dbpath,'appuser');
    if(!await databaseExists(dbstore)){
        print("Database NOt found ");  
    }else{
         deleteDatabase(dbstore); 
    }
    Database database; 
    

    User user=User.anonymous(); 
    openDatabase(dbstore,
        version: 1,
        onCreate: (db, version) {
          print("Creating user table "); 
          db.execute("create table user(username varchar,mobileno varchar) "); 
        },
        onOpen: (db)async{
              database=db;               
              print("Opened ");   
        }
    ).whenComplete(() {
        Session session=Session(database,user); 
        session.start(); 
        runApp(MetroApp());
        print("App Started"); 
    });
    
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: apptheme,
      home: Center(child: Text("MYAPP"),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
         return null ; 
  }
}

class MetroApp extends StatefulWidget {
  @override
  _MetroAppState createState() => _MetroAppState();
}

class _MetroAppState extends State<MetroApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

