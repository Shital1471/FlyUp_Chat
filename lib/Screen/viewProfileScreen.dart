import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_up/APIS/apis.dart';
import 'package:fly_up/Screen/auth/loginpage.dart';
import 'package:fly_up/Screen/homescreen.dart';
import 'package:fly_up/helper/dialogs.dart';
import 'package:fly_up/helper/my_date_util.dart';
import 'package:fly_up/main.dart';
import 'package:fly_up/modules/chat_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Joined On : ",
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            Text(
              MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),
              style: TextStyle(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
        //  floating button to add new user

        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: nq.width * .06),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: nq.width,
                    height: nq.height * .03,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(nq.height * .1),
                    child: CachedNetworkImage(
                      width: nq.height * 0.2,
                      height: nq.height * 0.2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: nq.width * .05,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: nq.width * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "About: ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      Text(
                        widget.user.about,
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
