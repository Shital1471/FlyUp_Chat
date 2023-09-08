import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_up/APIS/apis.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/dialogs.dart';
import '../../main.dart';
import '../homescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log("/nUser:${user.user}");
        log("/nUserAdditionalInfo: ${user.additionalUserInfo}");
        if ((await APIs.userExits())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log("/n _signInWithGoogle:$e");
      Dialogs.showSnackerbar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
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
            left: nq.width * 0.05,
            width: nq.width * 0.9,
            height: nq.height * 0.07,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 219, 235, 178),
                    shape: StadiumBorder(),
                    elevation: 1),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset(
                  "images/google.png",
                  height: nq.height * 0.05,
                ),
                label: RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      children: [
                        TextSpan(text: "Sign In with"),
                        TextSpan(
                            text: ' Google',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ))
                      ]),
                )))
      ]),
    );
  }
}
