import 'package:flutter/material.dart';
import 'package:metro_astha/session.dart';

class AppMessage extends StatelessWidget {
    final Message message;
    AppMessage(this.message);  
  @override
  Widget build(BuildContext context) {
    Color cardcolor=Colors.blue[100]; 
    if(message.messageType==MessageType.SUCCESS){
        cardcolor=Colors.green[200];
    }else if(message.messageType==MessageType.ERROR){
        cardcolor=Colors.red[100]; 
    }
    return Card(
        color: cardcolor,
        child: Column(
              children: [                  
                  ListTile( leading: Icon(Icons.notifications), title: Text(message.title??'Alert'),subtitle: Text(message.subtitle??''),)
              ],
        ),
        elevation: 11,        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}


Widget heading3(String text,BuildContext context,){
     return Text(text,style: Theme.of(context).textTheme.headline3,);
}

Widget heading4(String text,BuildContext context){
     return Text(text,style: Theme.of(context).textTheme.headline4,);
}
Widget heading5(String text,BuildContext context){
     return Text(text,style: Theme.of(context).textTheme.headline5,);
}

class GridStatusBlock extends StatelessWidget {
  final String title,value;
  final Color color ; 
  GridStatusBlock(this.title,this.value,this.color);
  @override
  Widget build(BuildContext context) {
    return  Container(
            color: this.color,                  
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$title",style: TextStyle(color: Colors.white),),
                Center(
        child: Container(                
          padding: EdgeInsets.all(15), 
          child: Text(value,style: TextStyle(color: Colors.white,fontSize: 45),),
        ),
                ),
              ],
            ),
          );
  }
}