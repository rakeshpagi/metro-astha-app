
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:metro_astha/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class Session{
        AppUser user;  
        Database database; 
        AppState appState=AppState();         
        FirebaseFirestore firestore; 
        Session(this.database,this.user);                 
        get anonymous=>this.user.anonymous; 
         UserCredential userCredential;
        start()async {
             
              firestore=FirebaseFirestore.instance; 
              userCredential = await FirebaseAuth.instance.signInAnonymously();
        }
        login(String userid,String password)async{
                 appState.setbusy();
                  print("Login $userid "); 
                  CollectionReference users = firestore.collection('users');
                  
                  users.add({'userid':userid,'password':password}).then((value)async {
                       print("User Added $value ");  
                        var list = await users.where('userid',isEqualTo: 'test').get();
                        list.docs.forEach((element) {
                              print(element.data()); 
                        });
                  });
                 
                 appState.setfree(); 
                 return true;  
        }
        doregister(AppUser newuser)async{

                 var users = firestore.collection('users'); 
                 var list =  await users.where('mobileno',isEqualTo: newuser.mobileno).get();
                 if(list==null){
                    return null; 
                 }
                 if(list.docs.length>0){
                      print('Already Registered'); 
                 }

                  var result = await users.add(newuser.toMap());
                  return result ;  
        }
}

class AppState extends ChangeNotifier{
    bool  _busy=false;

    setbusy(){
         _busy=true; notifyListeners(); 
    } 
    get busy=>this._busy; 

    setfree(){
        _busy=false;notifyListeners(); 
    }

}