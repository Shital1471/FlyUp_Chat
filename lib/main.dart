import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:fly_up/Screen/auth/loginpage.dart';
import 'package:fly_up/Screen/homescreen.dart';
import 'package:fly_up/Screen/profile_screen.dart';
import 'package:fly_up/widgets/chat_user_card.dart';

import 'Screen/splashScreen.dart';
import 'firebase_options.dart';

late Size nq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    nq = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size;
    _initializeFirebase();
    runApp(const MyApp());
  });
  // await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat On',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xffB4AED6),
          centerTitle: true,
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Notification',
    id: 'Fly_chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Fly Up Chats',
  );
  log('Notification Channel result:$result');
}
