import 'package:chat_01/res/color.dart';
import 'package:chat_01/res/fonts.dart';
import 'package:chat_01/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'firebase_options.dart';
import 'method/Authenticate.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     title: 'Flutter Demo',
     theme: ThemeData(
       primarySwatch: AppColors.primaryMaterialColor,
       scaffoldBackgroundColor: Colors.white,
       appBarTheme: const AppBarTheme(
           color: AppColors.whiteColor,
           centerTitle: true,
           titleTextStyle: TextStyle(fontSize: 22,fontFamily: AppFonts.sfProDisplayMedium,color: AppColors.primaryTextTextColor)
       ),
       textTheme: const TextTheme(
         //head-> display
         //
         displayLarge: TextStyle(fontSize: 40, fontFamily: AppFonts.sfProDisplayMedium, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),
         displayMedium: TextStyle(fontSize: 32, fontFamily: AppFonts.sfProDisplayMedium, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),
         displaySmall: TextStyle(fontSize: 28, fontFamily: AppFonts.sfProDisplayMedium, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.9),
         headlineMedium: TextStyle(fontSize: 24, fontFamily: AppFonts.sfProDisplayMedium, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),
         headlineSmall: TextStyle(fontSize: 20, fontFamily: AppFonts.sfProDisplayMedium, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),
         titleLarge: TextStyle(fontSize: 17, fontFamily: AppFonts.sfProDisplayBold, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),

         bodyLarge: TextStyle(fontSize: 17, fontFamily: AppFonts.sfProDisplayBold, color: AppColors.primaryTextTextColor, fontWeight: FontWeight.w500, height: 1.6),
         bodyMedium: TextStyle(fontSize: 14, fontFamily: AppFonts.sfProDisplayRegular, color: AppColors.primaryTextTextColor, height: 1.6),
         labelLarge: TextStyle(fontSize: 12, fontFamily: AppFonts.sfProDisplayBold, color: AppColors.primaryTextTextColor,  height: 2.26),

       ),

     ),
     home: Authenticate(),
   );
  }
}

