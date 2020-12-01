import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/models/grievance.dart';
import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/apppage.dart';

class NewGrievancePage extends StatefulWidget {
  @override
  _NewGrievancePageState createState() => _NewGrievancePageState();
}

class _NewGrievancePageState extends MetroAppPageState {
  int currentstep=0;  
  String grievancetype,description; 
  PageController pageController=PageController(initialPage: 0); 
  NewGrievanceActions newGrievanceActions;
  
  setGrievancetype(String type){
      
       setState(() {
           currentstep=1;
            grievancetype=type; 
            pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);
       });
  }
  setDescription(String desc){
       setState(() {
          description=desc; 
          pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.bounceIn) ; 
       });       
  }
  @override
  void initState() {    
    super.initState();
    newGrievanceActions=NewGrievanceActions(session, context);
  }

  @override
  PreferredSizeWidget getAppBar() {
    return AppBar(         
         title: Text("REGISTER NEW GRIEVANCE"), 
         leading: GestureDetector( onTap: (){
            Navigator.of(context).pop();
         }, child: Icon(Icons.arrow_back)),
         
    );
  }
  String currentStatusLabel(){
       var w='';
      if(currentstep==0){
           w=('Select Grievance Type'); 
      }else if(currentstep==1){
          w=(grievancetype); 
      }else{
           w=('Confirmation'); 
      }
     return w; 
  }
  doConfirm()async{
           Grievance newg =  await newGrievanceActions.createGrievance(grievancetype, description);
           if(newg!=null){
                 Navigator.of(context).pop(newg);
           }
  }
  @override
  Widget buildpage(BuildContext context) {

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Flexible(
                flex: 1,
                child: AnimatedAlign(alignment:{0:Alignment.centerLeft,1:Alignment.center,2:Alignment.centerRight}[currentstep],
                        duration: Duration(seconds:1),
                       child:  Chip ( label: Text(currentStatusLabel()??'SELECT GRIEVANCE' ) ),
                ) ),
              Expanded( flex: 9,
                              child: 
                      PageView(
                                pageSnapping: false,
                                physics: new NeverScrollableScrollPhysics(),
                      controller: pageController,
                    onPageChanged: (i){
                        setState(() {                               
                            currentstep=i;
                        });
                    },
                    children: [
                        TypePage(setGrievancetype),
                        EntryPage(setDescription),
                        ConfirmPage(grievancetype,description,doConfirm ),
                    ],
                )
              ),
              Flexible(flex: 1,
                  child: currentstep==0?Container():  MaterialButton(onPressed: (){
                     pageController.jumpTo(0);
              },child: Text('Reset'),),)
        ],
    );

  }
}

class TypePage extends StatelessWidget {
  final List<String> types=["INCREMENT","PROMOTION","SALARY"];
  final Function onselect; 
  TypePage(this.onselect);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context,i){
          return ListTile(title: Text(types[i]),leading: Icon(Icons.circle),enabled: true,
              onTap: ()=>onselect(types[i]),
            );
    }
    ,itemCount: types.length,);
  }
}


class EntryPage extends StatefulWidget {
  final Function onentry; 
   EntryPage(this.onentry); 
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  TextEditingController controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
            
           child: SingleChildScrollView(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Give you description here'),
                        TextFormField(decoration: InputDecoration( 
                                hintText: 'Please Give Description'
                          ),maxLines: 10, controller: controller, ),
                          Divider(),
                          RaisedButton(onPressed: (){
                                      FocusScope.of(context).unfocus();  
                                      widget.onentry(controller.text); 
                                },child: Text('PROCEED'),

                                )
                      ],
                    ),
           ),
    );
  }
}


class ConfirmPage extends StatelessWidget {
  final String type,description;
   final Function onconfirm; 
  ConfirmPage(this.type,this.description,this.onconfirm);
  @override
  Widget build(BuildContext context) {
    return Container(

          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Container(child: Center(child: Text(type,style: TextStyle(fontWeight: FontWeight.bold),),),
                    color: Colors.blueAccent[100],padding: EdgeInsets.all(15),),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(description),
                  ),
                  Divider(),
                  MaterialButton(onPressed: (){
                        onconfirm();
                  },child: Text('Confirm'),color: Colors.red,)
              ], 
          ),
    );
  }
}


class NewGrievanceActions  {
      Session session; 
      BuildContext context; 
      NewGrievanceActions(this.session,this.context); 
     Future<Grievance> createGrievance(String type,String description){
            FirebaseFirestore fireStore = session.firestore; 
            String date = DateTime.now().toString();
            session.appState.setbusy();
            Completer<Grievance> completer=Completer(); 
            fireStore.collection('glist').add({"gtype":type,"gdescription":description,"gdate":date ,"mobileno":session.user.mobileno }).then((value) {
                   Grievance newg=Grievance(value.id,type: type,description: description,date: date);
                   session.database.insert('grievances',newg.toMap()  );
                   completer.complete(newg);
                   session.appState.setfree();
            }).catchError((e){
                  print("Some Error $e "); 
                  completer.complete(null);  
                  session.appState.setfree(); 
                  session.sendErrorMessage("Error",subtitle: 'Unable to Save Grievance. Try Again');
            }); 
          return completer.future;
      }
}