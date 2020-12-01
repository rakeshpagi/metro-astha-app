
import 'package:flutter/material.dart';
import 'package:metro_astha/viewutils/viewutils.dart';
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
          appBar: getAppBar(),
          bottomNavigationBar: getBottomNavigationBar(), 
          floatingActionButton: getFloatingActionButton() ,               
          body: ChangeNotifierProvider.value(
                      value: messageHandler,
                      child: Stack(children: [
                buildpage(context),
               
                SafeArea(                           
                          child: Consumer<MessageHandler>(
                            builder:(context,handler,child)=> 
                          ListView.builder(  
                           padding: EdgeInsets.all(8),
                           shrinkWrap: true,
                           itemBuilder: (context,i){
                             return AppMessage(messageHandler.messages[i]);
                         },itemCount:messageHandler.messages.length ,
                         ),
                  ),
                ),
                 Consumer<AppState>(builder: (context,state,child){
                    return Visibility(child: Column(
                      children: [
                        LinearProgressIndicator(),
                        Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(0.5)
                          ),
                        )
                      ],
                    ),visible: state.busy,);
                }, ),
                
        ],),
          ),      
        
    );
  }

  Widget buildpage(BuildContext context){
             return Container();
  }

  getBottomNavigationBar(){
       return null ;
  }
  Widget getFloatingActionButton(){
       return null;
  }
  PreferredSizeWidget getAppBar(){
       return null; 
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