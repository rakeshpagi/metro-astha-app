import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/apptheme.dart';

import 'package:metro_astha/models/user.dart';

import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/login.dart';
import 'package:metro_astha/views/newgrievance.dart';
import 'package:metro_astha/views/registration.dart';
import 'package:metro_astha/views/userhome.dart';

import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized(); 
    await Firebase.initializeApp();     
    var dbpath=await getDatabasesPath() ; 
    var dbstore=join(dbpath,'appuser');
    if(!await databaseExists(dbstore)){
        print("Database NOt found ");  
    }else{
       //  deleteDatabase(dbstore); 
    }
    Database database; 
    

    AppUser user=AppUser.anonymous(); 
    openDatabase(dbstore,
        version: 2,
        onCreate: (db, version) {
          print("Creating user table "); 
          db.execute("create table user(username varchar,mobileno varchar) "); 
          db.execute("create table grievances(gid varchar,gtype varchar,gdescription varchar,gstatus  varchar,gdate varchar ) "); 
        },
        onUpgrade: (db,v,i){

        },
        onOpen: (db)async{
              database=db;            
              var users = await database.query("user");   
              if(users.length==1){
                user=AppUser.fromMap(users.first); 
                print("Already Login "); 
              }else{
                   print("User Not Exists ");
              }
              print("Opened ");   
        }
    ).whenComplete(() {
        Session session=Session(database,user); 
        //session.start(); 
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
  Future<bool> start ; 
  @override
  void dispose() {
    
    super.dispose();
    widget.session.dispose();
  }
  @override
  void initState() {
    
    super.initState();
    start=widget.session.start(); 
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder (
          future: start,
          builder: (context,snap)=>!snap.hasData? Center(child: CircularProgressIndicator(),) :MultiProvider(providers: [
          ChangeNotifierProvider.value(value: widget.session.appState                        
          ),
          Provider<Session>.value(value: widget.session)
          
      ]  ,
        builder:(context,child)=>MaterialApp(
            theme: apptheme,
            onGenerateRoute: (settings){
                switch(settings.name){
                     case '/':
                        return MaterialPageRoute(builder: (context)=> widget.session.user.anonymous?LoginPage():UserHomePage() );
                        break;
                      case '/register':
                         return MaterialPageRoute(builder: (context)=> RegistrationPage()   );
                         break;
                      case '/home':
                        return MaterialPageRoute(builder: (context)=>UserHomePage()); 
                        break; 
                      case '/login':
                        return MaterialPageRoute(builder: (context)=>LoginPage()); 
                        break;
                      case '/newgrievance':
                        return MaterialPageRoute(builder: (context)=>NewGrievancePage()); 
                }
                return MaterialPageRoute(builder: (context)=>LoginPage());
            },
        ),

      ),
    );
  }
}

