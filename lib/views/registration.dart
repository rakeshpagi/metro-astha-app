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
  TextEditingController namecontroller = TextEditingController() ,
        mobilenocontroller=TextEditingController(),passwordcontroller=TextEditingController(); 
   
  @override
  Widget buildpage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var namefield=RegisterField(label: 'Name',iconlabel: Icons.perm_identity, textcontroller: namecontroller, ); 
    var mobilenofield=RegisterField(label: 'Mobile No',iconlabel: Icons.mobile_friendly,textcontroller: mobilenocontroller, ) ; 
    var passwordfield=RegisterField(label: 'PassWord',iconlabel: Icons.lock_open,obscure: true,textcontroller: passwordcontroller,); 
    return  CustomScrollView(
      
       slivers: [
           SliverAppBar(
               title: Text('Register'),expandedHeight: size.height*0.3,elevation: 5,floating: true,
           ),
           SliverList(delegate: SliverChildListDelegate([
              namefield,
              mobilenofield,
              passwordfield,
              SizedBox(height: 25,),
              RaisedButton(onPressed: ()async{
                      print("Saving  ${namecontroller.text}");
                      AppUser newuser=AppUser(mobileno: mobilenocontroller.text,
                        username: namecontroller.text,
                        password: passwordcontroller.text
                        );
                        
                        var user = await context.read<Session>().doregister(newuser); 
                        print("Response ${user['username']} ");
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
  final textcontroller; 
  RegisterField({this.label,this.iconlabel,this.obscure=false,this.textcontroller});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(prefixIcon: Icon(iconlabel),
              labelText: label,              
                                             
        ), 
          obscureText: obscure,controller: textcontroller,
        );          
  }
  
}