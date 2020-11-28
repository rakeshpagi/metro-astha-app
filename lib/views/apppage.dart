
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
  @override
  void initState() {    
    super.initState();

  }
  @override
  Widget build(BuildContext context) {  
         
    return Scaffold(              
          body: Stack(children: [
              buildpage(context),
              Consumer<AppState>(builder: (context,state,child){
                  return Visibility(child: LinearProgressIndicator(),visible: state.busy,);
              }, )
        ],),      
        
    );
  }

  Widget buildpage(BuildContext context){
             return Container();
  }
}