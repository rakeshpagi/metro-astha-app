import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/apptheme.dart';

import 'package:metro_astha/models/user.dart';

import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/login.dart';
import 'package:metro_astha/views/registration.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized(); 
    Firebase.initializeApp(); 

    var dbpath=await getDatabasesPath() ; 
    var dbstore=join(dbpath,'appuser');
    if(!await databaseExists(dbstore)){
        print("Database NOt found ");  
    }else{
         deleteDatabase(dbstore); 
    }
    Database database; 
    

    AppUser user=AppUser.anonymous(); 
    openDatabase(dbstore,
        version: 1,
        onCreate: (db, version) {
          print("Creating user table "); 
          db.execute("create table user(username varchar,mobileno varchar) "); 
        },
        onOpen: (db)async{
              database=db;            
              var users = await database.query("user");   
              if(users.length==1){
                user=AppUser.fromMap(users.first); 
              }
              print("Opened ");   
        }
    ).whenComplete(() {
        Session session=Session(database,user); 
        session.start(); 
        runApp(MetroApp(session));
        print("App Started"); 
    });
    
}


class MetroApp extends StatefulWidget {
  final Session session ; 
  MetroApp(this.session);  

  @override
  _MetroAppState createState() => _MetroAppState();
}

class _MetroAppState extends State<MetroApp> {
  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(providers: [
        ChangeNotifierProvider.value(value: widget.session.appState                        
        ),
        Provider<Session>.value(value: widget.session)
        
    ]  ,
      builder:(context,child)=>MaterialApp(
          theme: apptheme,
          onGenerateRoute: (settings){
              switch(settings.name){
                   case '/':
                      return MaterialPageRoute(builder: (context)=> LoginPage() );
                      break;
                    case '/register':
                       return MaterialPageRoute(builder: (context)=> RegistrationPage()   );
                       break;
                    
              }
              return MaterialPageRoute(builder: (context)=>LoginPage());
          },
      ),

    );
  }
}

