// ignore: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_up/APIS/apis.dart';
import 'package:fly_up/Screen/auth/loginpage.dart';
import 'package:fly_up/Screen/homescreen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,statusBarColor: Colors.white));
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    nq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to FlyUp chat"),
      ),
      body: Stack(children: [
        Positioned(
            top: nq.height * 0.2,
            left: nq.width * 0.25,
            width: nq.width * 0.5,
            child: Image.asset("images/communication.png")),
        Positioned(
            bottom: nq.height * 0.15,
            width: nq.width,
            child: Text(
              "Mabe By Shital Gupta",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 19, color: Colors.black87, letterSpacing: 0.5),
            ))
      ]),
    );
  }
}
