
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
         StreamController<Message> messaging = StreamController.broadcast(); 
        start()async {

               await Firebase.initializeApp();                   
              userCredential = await FirebaseAuth.instance.signInAnonymously();
              firestore=FirebaseFirestore.instance; 
        }
        sendMessage(String m){
              messaging.sink.add(Message(m));
        }
        sendSuccessMessage(String m,{subtitle='' }){
              messaging.sink.add(Message.success(m,subtitle: subtitle));
        }
         sendErrorMessage(String m,{subtitle:''}){
              messaging.sink.add(Message(m,subtitle: subtitle,messageType: MessageType.ERROR ));
        }
        Future<bool> login(String userid,String password)async{
                 appState.setbusy();
                  print("Login $userid password $password "); 
                  Completer<bool> completer=Completer();
                  CollectionReference users = firestore.collection('users');                    
                  var rusers = await  users.where('mobileno',isEqualTo: userid).where('password',isEqualTo: password).get();
                  print(rusers.docs);
                  if(rusers.docs.length>0){
                        var ruser = rusers.docs.first;                                                 
                        user=AppUser(mobileno: ruser.data()['mobileno'],username: ruser.data()['username'] );
                        database.insert("user", user.toMap()); 
                        completer.complete(true);
                        appState.setfree();
                  }else{
                      sendErrorMessage('Invalid User/Password');  
                      completer.complete(false); 
                  }
                 
                 appState.setfree(); 
                 return completer.future;  
        }
        doregister(AppUser newuser)async{
                 appState.setbusy();
                 var users = firestore.collection('users'); 
                 var list =  await users.where('mobileno',isEqualTo: newuser.mobileno).get();
                 if(list==null){
                    appState.setfree();
                    return null; 
                 }
                 if(list.docs.length>0){
                      print('Already Registered'); 
                      sendErrorMessage('Already Registered',subtitle:newuser.mobileno) ; 
                      appState.setfree();
                      return list.docs.first ;
                 }

                  var result = await users.add(newuser.toMap());
                  appState.setfree(); 
                  sendSuccessMessage('SuccessFully Registered',subtitle:newuser.username);
                  return await result.get() ;  
        }
        logout()async{
            if(!user.anonymous){
                appState.setbusy(); 
                await database.delete("user"); 
                user=AppUser.anonymous();
                appState.setfree(); 
            }
        }
        get messagestream=>messaging.stream;

        dispose(){
              messaging.close();  
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

class Message{
      String  title,subtitle; 
      MessageType messageType=MessageType.INFO;
      Message(this.title,{this.subtitle,this.messageType=MessageType.INFO}); 
      error()=>this.messageType=MessageType.ERROR;  
      Message.success(this.title,{this.subtitle}):messageType=MessageType.SUCCESS; 
}
 enum MessageType{
      INFO,
      ERROR, 
      SUCCESS   
  }