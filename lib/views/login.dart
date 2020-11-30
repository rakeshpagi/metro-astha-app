import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:metro_astha/apptheme.dart';
import 'package:metro_astha/session.dart';
import 'package:provider/provider.dart';
import 'package:metro_astha/views/apppage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends MetroAppPageState {
  @override
  Widget buildpage(BuildContext context) {
    return Stack(
               children: [    
                Container(
                      decoration: BoxDecoration(
                            
                            gradient: LinearGradient(colors: [ Colors.black.withOpacity(0.5),Colors.black,Colors.black ],begin: Alignment.topCenter,end: Alignment.bottomCenter ),
                          image: DecorationImage(image: NetworkImage('https://img.staticmb.com/mbcontent/images/uploads/2020/2/pune%20metro%20rail.jpg')
                          ,fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop ))
                              ),
                              child: Container(),
                ),         
              SingleChildScrollView(
                          
                              child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.stretch,                  
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [ 
                           SizedBox(height:150),
                           Center(
  
                               child: ClipOval(
  
                   child: Image.asset(LAUNCHICON_ASSET,width: 90,height: 90,fit: BoxFit.cover,                                
  
                       colorBlendMode: BlendMode.lighten,
  
                     )
  
                               ),
  
                             ),
  
                           SizedBox(height: 150,),
  
                           Theme( data: appthemedark,

                             child: LoginForm()
                             ),
                          SizedBox(height:10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(  child: RichText(text: TextSpan(text: 'Not Registered ? ', 
                                  style: TextStyle(color:Colors.grey),
                                children: [  
                                  TextSpan(style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
                                  text: ' Sign Up  ',recognizer: TapGestureRecognizer()..onTap=(){
                                          print("Starting Register"); 
                                         Navigator.of(context).pushNamed('/register'); 
                                  }  ,   )]), 
                              )),
                          )
  
                  ],),
              ),
],
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode focususer=FocusNode();
  final TextEditingController mobilenocontroller=TextEditingController(),passwordcontroller=TextEditingController();  
  @override
  Widget build(BuildContext context) {
    
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginField(label:'MobileNo',iconlabel: Icons.perm_identity,textEditingController: mobilenocontroller,),
          LoginField(label: 'PassWord',iconlabel:Icons.lock_open,obscure: true,textEditingController: passwordcontroller,),          
          Row(  
              mainAxisAlignment: MainAxisAlignment.end, children: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Forgot Password', style: TextStyle(color: Colors.white,),  ),
          )],),
          SizedBox(height:15),
          MaterialButton(onPressed: ()async{
                   
                   context.read<Session>().login(mobilenocontroller.text,passwordcontroller.text ).then((value) {
                        if(value){
                            
                            Navigator.of(context).pushReplacementNamed('/home'); 
                        }
                   }); 

          }, child: Text('Sign In'),color: Colors.pinkAccent,padding: EdgeInsets.all(15), )
    ],);
  }
}

class LoginField extends StatelessWidget {
  final String  label; 
  final IconData iconlabel; 
  final bool obscure;
  final TextEditingController textEditingController; 
  LoginField({this.label,this.iconlabel,this.obscure=false,this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(prefixIcon: Icon(iconlabel),
              labelText: label,              
                                          
        ), 
          obscureText: obscure,controller: textEditingController
        );          
  }
}