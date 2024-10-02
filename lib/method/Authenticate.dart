
import 'package:chat_01/ui/homescreen.dart';
import 'package:chat_01/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authenticate extends StatelessWidget {

final FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
   if(_auth.currentUser!=null){
     return Homescreen();
   }else{
     return LoginScreen();
   }
  }
}
