import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/models/user.dart';
import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/apppage.dart';
import 'package:metro_astha/views/resolvepage.dart';
import 'package:metro_astha/viewutils/viewutils.dart';
import 'package:provider/provider.dart';

class UserHomeActions extends ChangeNotifier{
      Session session; 
      BuildContext context ; 
      UserHomeActions(this.session,this.context);
      List<QueryDocumentSnapshot> glist ;
      
      logout()async{
                 await session.logout();
                 Navigator.of(context).pushReplacementNamed('/login'); 
      }
      Future<List<QueryDocumentSnapshot>> loadgrievances()async{
           QuerySnapshot snapshot = await  session.firestore.collection('glist').where("mobileno",isEqualTo: session.user.mobileno).get();
           glist = snapshot.docs; 
           return snapshot.docs; 
      }
}

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends MetroAppPageState {
  UserHomeActions homeActions; 
  PageController pageController=PageController();
  int currentMenu= 0 ;
  ValueNotifier menuNotifier = ValueNotifier(0); 
  @override
  void initState() {    
    super.initState();
    homeActions=UserHomeActions(session, context); 
  }
  @override
  Widget buildpage(BuildContext context) {
    return ChangeNotifierProvider<UserHomeActions>.value(
          value: homeActions ,
          child: PageView(
                  controller: pageController,
                      children: [
                  Stack(
  
                children: [
  
                      FutureBuilder(
  
                           future: homeActions.loadgrievances(),
  
                          builder:(context,snapshot){
  
                            if(snapshot.connectionState!=ConnectionState.done){
  
                                 return Center(child: CircularProgressIndicator());
  
                            }
  
                          return CustomScrollView(
  
                          slivers: [
  
                              UserAppBar(),
  
                              UserGridStatus(),
  
                              GrievanceList()
  
                          ], 
  
                        );
  
                          }
  
                      ),                
  
                        
  
                ],
  
        ),
          ResolvePage()
],
          ),
    );
  }

    @override
  getBottomNavigationBar() {    

    
    return ValueListenableBuilder(
           valueListenable: menuNotifier,

          builder:  (context,value,child)=> BottomNavigationBar(
                        elevation: 5,                    
                        items: [
                          
                          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
                          
                              BottomNavigationBarItem(icon: Icon(Icons.list),label: 'Resolve',   )                        
                      ], 
                      onTap: (t){
                         
                              pageController.animateToPage(t, duration: Duration(seconds: 1), curve: Curves.easeInOutQuart ); 
                              currentMenu=t;
                              menuNotifier.value=t; 
                          
                      },currentIndex: menuNotifier.value,
                      ),
    );
  }

  @override
  Widget getFloatingActionButton() {
    
    return FloatingActionButton(onPressed: (){
            Navigator.of(context).pushNamed('/newgrievance').whenComplete(() {
                setState(() {
                      /// refresh All 
                      print("Refresing Page");  
                });
            });
    },child: Icon(Icons.add),);
  }

}
class UserAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppUser user = context.select((Session value) => value.user);    
    return SliverAppBar(
        title: Text("Profile"),
        actions: [
            IconButton(icon: Icon(Icons.logout), onPressed: (){
                context.read<UserHomeActions>().logout();
            },color: Colors.grey,)
        ],
        backgroundColor: Colors.white,
        elevation: 5, 
        
        expandedHeight: 210,        
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: ClipOval(  child: Image.network('https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png',width: 50,),) ),
            Center(child: heading5("Hi, ${user.username}",context),),
            Center(child: Text("Have a Great day today!")),
          ],
        ),
        floating: true,
    );
  }
}

class UserGridStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SliverGrid.count(crossAxisCount: 2,
    childAspectRatio: 1.5,
    children: [
          GridStatusBlock('POSTED', context.select(( UserHomeActions value) => value).glist.where((element) => element.data()['status']!='C' ).length.toString(), Colors.teal[200]),
          GridStatusBlock('RESOLVED', context.select(( UserHomeActions value) => value).glist.where((element) => element.data()['status']=='C' ).length.toString(), Colors.pinkAccent[100]),
    ],);
  }
}

class GrievanceList extends StatefulWidget {
  @override
  _GrievanceListState createState() => _GrievanceListState();
}

class _GrievanceListState extends State<GrievanceList> {

  @override
  Widget build(BuildContext context) {
    List glist = context.select((UserHomeActions value) => value).glist;     
          return SliverList(delegate: SliverChildBuilderDelegate( 
              (context,i){
                    QueryDocumentSnapshot rec = glist[i];
                   return ListTile(
                        leading: Icon(Icons.circle,color: rec.data()['status']=='C'?Colors.pink[200]: Colors.teal[200],),
                        title: Text(rec['gtype']),subtitle: Text(rec['gdate']),);  
              },childCount: glist.length
          ),);         
    
  }
}


class ResolvePage extends StatefulWidget {
  @override
  _ResolvePageState createState() => _ResolvePageState();
}

class _ResolvePageState extends State<ResolvePage> {
  int currentTab=0; 
  Session session ; 
  
  onChangeTab(t){
       setState(() {
            currentTab=t; 
       });
  }
  Future<List<Map> > getPendingList()async{
      
       QuerySnapshot qs = await  session.firestore.collection('glist').where('currenthandler',isEqualTo: session.user.mobileno ).get().catchError((e){
               session.sendErrorMessage(e);
       });   
       
        print("Qs ${qs.docs} ");  
        List<Map> results=[]; 

         var i = qs.docs.where((element) => element.data()['status']!='C').iterator;  
         if(currentTab==1){
            i = qs.docs.where((element) => element.data()['status']=='C').iterator;
         }
         while(i.moveNext()){
              Map r=i.current.data(); 
              String mobileno =  i.current.get('mobileno');
              QuerySnapshot s = await  session.firestore.collection('users').where('mobileno',isEqualTo: mobileno).get();
              if(s.docs.length>0){
                   r['user']=s.docs.elementAt(0).data();
                   r['gid']=i.current.id; 
              } 
              print('Adding '); 
              results.add(r);
         }
         
         print("Results $results");
       return results;  
  }
  @override
  void initState() {
    
    super.initState();
    // session = context.select((Session value) => value);
    session = context.read<Session>();
  }
  @override
  Widget build(BuildContext context) {    
    return SafeArea(
          child: Container(
            child: Column(
                 children: [
                    DefaultTabController(length: 2,
                    
                     child: TabBar(tabs: [
                        Tab(child: Text("Pending",style: TextStyle(color: Colors.black),),icon: Icon(Icons.lock_clock ),),
                        Tab(child: Text("Completed"),icon: Icon(Icons.check ),)
                    ],  onTap: onChangeTab,
                    ), initialIndex: currentTab, ),
                    Expanded(child:   
                        FutureBuilder<List<Map>>(
                          future: getPendingList(),
                          builder: (context,snap){
                              if(!snap.hasData)return Center(child: CircularProgressIndicator());   
                              
                              return ListView.builder(itemBuilder: (context,i){
                                   Map  data =  snap.data.elementAt(i);
                                   //print(data);
                                  return Card(
                                        elevation: 9,
                                                                      child: ListTile(                                 
                                        contentPadding: EdgeInsets.all(8),     
                                        
                                        leading: Icon(Icons.circle,color: data['status']=='C'?Colors.green :  Colors.pink,),
                                        title: Text('${data['user']['username']} '),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data['gtype']),
                                            Text(data['gdate'])
                                          ],
                                        ),                                      
                                        trailing:CircleAvatar(child: Text('I')),
                                        onTap: (){
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResponsePage(data) )); 
                                        },
                                        ),
                                  );
                              },itemCount: snap.data.length,);  
                          }
                      )
                    
                    )
                 ],
            ),
      ),
    );
  }
}