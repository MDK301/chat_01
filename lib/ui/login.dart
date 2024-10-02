import 'package:chat_01/method/Menthods.dart';
import 'package:chat_01/ui/createaccount.dart';
import 'package:chat_01/ui/homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginScreen extends StatefulWidget {
  final String? email;
  const LoginScreen({Key? key, this.email}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  bool isLoading =false;
  @override
  void initState() {
    super.initState();
    String userEmail = widget.email ?? "";
    _email.text = userEmail; // Gán giá trị cho controller
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading?
          Center(child: Container(
            height: size.height/20,
            width: size.width/20,
            child: CircularProgressIndicator(),
          ),)
          :SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
                alignment: Alignment.centerLeft,
                width: size.width / 1.2,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.arrow_back_ios))),
            SizedBox(
              height: size.height / 50,
            ),
            Container(
              width: size.width / 1.3,
              child: Text(
                "Welcome",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: size.width / 1.3,
              child: Text(
                "Sign In To Continue!",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Container(
                width: size.width,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), // Use email icon
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child: TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), // Use email icon
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            customButton(size),
            SizedBox(
              height: size.height / 20,
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CreateAccount()));
              },
              child: Text(
                "Create Account",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: (){
          if(_email.text.isNotEmpty&&_password.text.isNotEmpty){
setState(() {
  isLoading=true;
});
logIn(_email.text, _password.text).then((user){
  if(user!=null){
    print("Login Sucessfull");
    setState(() {
      isLoading=false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (_)=>Homescreen()));
  }else{
    print("Login Failed");
    setState(() {
      isLoading=false;
    });
  }
});
          }else{
            print("please fill form");
          }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget field(Size size, String hintText, IconData icon,TextEditingController cont) {
    return Container(
      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
            prefix: Icon(icon),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
