import 'package:metro_astha/models/user.dart';
import 'package:sqflite/sqflite.dart';

class Session{
        User user;  
        Database database; 
        Session(this.database,this.user);                 
        get anonymous=>this.user.anonymous; 
        start(){

        }
        login(){

        }
}