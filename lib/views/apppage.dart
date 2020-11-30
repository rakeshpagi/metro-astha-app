
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../session.dart';
const String LAUNCHICON_ASSET='./assets/images/launch_icon.png';
class MetroAppPage extends StatefulWidget {
  @override
  MetroAppPageState createState() => MetroAppPageState();
}

class MetroAppPageState extends State {
  Session session ;  
  MessageHandler messageHandler ;
  @override
  void initState() {    
    super.initState();
    messageHandler=MessageHandler(); 
    session = context.read<Session>();
    session.messaging.stream.listen((event) {
          messageHandler.addMessage(event); 
    });
  }
  @override
  Widget build(BuildContext context) {  
         
    return Scaffold(              
          body: ChangeNotifierProvider.value(
                      value: messageHandler,
                      child: Stack(children: [
                buildpage(context),
                Consumer<AppState>(builder: (context,state,child){
                    return Visibility(child: LinearProgressIndicator(),visible: state.busy,);
                }, ),
                Consumer<MessageHandler>(
                        builder:(context,handler,child)=> ListView.builder(  
                         shrinkWrap: true,
                         itemBuilder: (context,i){
                           return Card(
                               child: Container(
                                   padding: EdgeInsets.all(8),
                                   color: Colors.white,
                                   child: Text(messageHandler.messages[i].title,style: Theme.of(context).textTheme.headline5,),
                               ),
                           );
                       },itemCount:messageHandler.messages.length ,),
                ),
                
        ],),
          ),      
        
    );
  }

  Widget buildpage(BuildContext context){
             return Container();
  }
}

class  MessageHandler extends ChangeNotifier{
    List<Message>  _messages = List(); 
    int opacity = 0; 
    addMessage(Message m){  
        _messages.add(m); 
        if(_messages.length>3){
             messages.removeAt(0); 
        }
        notifyListeners(); 
        Future.delayed(Duration(seconds: 5)).whenComplete((){
            clear();
        }); 
    }
    clear(){
        _messages.clear(); 
        print("Clearing Messages "); 
        notifyListeners();  
    }
    List<Message> get  messages=>this._messages; 

}