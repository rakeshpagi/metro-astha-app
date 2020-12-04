import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/views/apppage.dart';

class ResponsePage extends StatefulWidget {
  final Map g ; 
  ResponsePage(this.g);  
  @override
  _ResponsePageState createState() => _ResponsePageState(g);
}

class _ResponsePageState extends MetroAppPageState{
  Map g; 
  _ResponsePageState(this.g);
  
  Future<List> loadremarks()async{
         String gid = g['gid']; 
         print('getting doc $gid '); 
         QuerySnapshot qs = await  session.firestore.collection('glist').doc(gid).collection('remarks').orderBy('t',descending: true).get(); 
       //  return   qs.docs.reversed.toList(); 
         return qs.docs;
  }
  addRemark(rem){
      if(rem==''){
          return session.sendErrorMessage('Remarks Cannot Be Null');
      }
      session.appState.setbusy(); 
      var t=DateTime.now().microsecondsSinceEpoch; 
      var remark={"remarks":rem,"mobileno":session.user.mobileno,"remarksdate":DateTime.now().toString(),"t":t };
      session.firestore.collection('glist').doc(g['gid']).collection('remarks').add(remark).whenComplete((){
             setState(() {
                      ///     
                      session.appState.setfree();
             });
      } ).catchError((e){
             session.appState.setfree();
             session.sendErrorMessage(e);
      });
  }
  markasComplete(){
         session.firestore.collection('glist').doc(g['gid']).update({'status':'C','completedate':DateTime.now().toString() }  ).whenComplete(() {
            setState(() {
                print('MARKED AS COMPLETED'); 
                g['status']='C'; 
            });
         } );
  }
  @override
  Widget buildpage(BuildContext context) {
    TextEditingController remarkscontroller=TextEditingController(); 
    return Container(
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Center(child: Text(g['gtype'],style:Theme.of(context).textTheme.headline5 ,)),
                Spacer(),
                MaterialButton( elevation: 15, child: Icon(Icons.check,), 
                  color: Colors.green,
                onPressed: (){
                    markasComplete();
                },shape: CircleBorder(),)
              ],
            ),
            Expanded(
                child: FutureBuilder<List>(
                    future: loadremarks(),
                    builder: (context,snap){
                      if(!snap.hasData){
                         return Center(child: CircularProgressIndicator(),); 
                      }
                      return ListView.builder(
                            reverse: true,                                 
                            padding: EdgeInsets.all(0),                       
                            itemBuilder: (context,i){
                          return Card(
                              child: ListTile(                              
                              title: Container(  child: Text('${snap.data.elementAt(i).data()['remarks'] } ')),),
                          );
                      },itemCount: snap.data.length,);
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: g['status']=='C'?Text('THIS IS RESOLVED ') : Row(                
                children: [
                  Expanded(child: TextField( controller: remarkscontroller, maxLines: 2,
                  decoration: InputDecoration(border: OutlineInputBorder(),hintText: 'Type Response Remarks' ), )),                  
                  IconButton(onPressed: (){
                      addRemark(remarkscontroller.text); 
                  },icon: Icon(Icons.send,color: Colors.red,),)
              ],),
            )
          ],
        ),
    );
  }
  @override
  PreferredSizeWidget getAppBar() {
    
    return AppBar( leading: GestureDetector(child: Icon(Icons.arrow_back,color: Colors.white,),onTap: (){
          Navigator.of(context).pop(); 
    },),  title: Text(g['user']['username']),);
  }
}