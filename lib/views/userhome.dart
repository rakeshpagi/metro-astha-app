import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/models/user.dart';
import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/apppage.dart';
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
  @override
  void initState() {    
    super.initState();
    homeActions=UserHomeActions(session, context); 
  }
  @override
  Widget buildpage(BuildContext context) {
    return ChangeNotifierProvider<UserHomeActions>.value(
          value: homeActions ,
          child: Stack(
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
    );
  }

    @override
  getBottomNavigationBar() {    
    return BottomNavigationBar(
                      elevation: 5,                    
                      items: [
                        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.list),label: 'Resolve')
                    ],);
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
          GridStatusBlock('POSTED', context.select(( UserHomeActions value) => value).glist.length.toString(), Colors.teal[200]),
          GridStatusBlock('RESOLVED', '0', Colors.pinkAccent[100]),
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
                        leading: Icon(Icons.circle,color: Colors.teal[200],),
                        title: Text(rec['gtype']),subtitle: Text(rec['gdate']),);  
              },childCount: glist.length
          ),);         
    
  }
}