import 'package:flutter/material.dart';
import 'package:metro_astha/models/user.dart';
import 'package:metro_astha/session.dart';
import 'package:metro_astha/views/apppage.dart';
import 'package:provider/provider.dart';
class RegistrationPage extends StatefulWidget {
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends MetroAppPageState {
  @override
  Widget buildpage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  CustomScrollView(
      
       slivers: [
           SliverAppBar(
               title: Text('Register'),expandedHeight: size.height*0.3,elevation: 5,floating: true,
           ),
           SliverList(delegate: SliverChildListDelegate([
              RegisterField(label: 'Name',iconlabel: Icons.perm_identity),
              RegisterField(label: 'Mobile No',iconlabel: Icons.mobile_friendly ) ,
              RegisterField(label: 'PassWord',iconlabel: Icons.lock_open,obscure: true,),
              SizedBox(height: 25,),
              RaisedButton(onPressed: ()async{
                      var user = await context.read<Session>().doregister(AppUser(mobileno: '123456789',username: 'NAME')); 
                      print("Response $user ");
              },child: Text("Register"),padding: EdgeInsets.all(15),
              )
           ], ),)
       ],
      );
  }
}

class RegisterField extends StatelessWidget {
  final String  label; 
  final IconData iconlabel; 
  final bool obscure;
  RegisterField({this.label,this.iconlabel,this.obscure=false});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(prefixIcon: Icon(iconlabel),
              labelText: label,              
                                             
        ), 
          obscureText: obscure,
        );          
  }
}