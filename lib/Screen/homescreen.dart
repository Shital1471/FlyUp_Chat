import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_up/APIS/apis.dart';
import 'package:fly_up/Screen/profile_screen.dart';
import 'package:fly_up/main.dart';
import 'package:fly_up/widgets/chat_user_card.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/dialogs.dart';
import '../modules/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchlist = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          APIs.updateActiveStatus(true);
        if (message.toString().contains('pause'))
          APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
          onWillPop: () {
            if (_isSearching) {
              setState(() {
                _isSearching = !_isSearching;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name,Email......'),
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.5,
                      ),
                      onChanged: (val) {
                        _searchlist.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _searchlist.add(i);
                          }
                          setState(() {
                            _searchlist;
                          });
                        }
                      },
                    )
                  : Text("Chat On"),
              actions: [
                // search user button
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching!
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                // more feature button
                IconButton(
                    onPressed: () {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            ),
            //  floating button to add new user
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _adduserDialog();
              },
              child: Image.asset("images/add-group.png"),
            ),
            body: StreamBuilder(
                stream: APIs.getUserId(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return StreamBuilder(
                          stream: APIs.getAllUsers(
                              snapshot.data?.docs.map((e) => e.id).toList() ??
                                  []),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.none:
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              case ConnectionState.active:
                              case ConnectionState.done:
                                final data = snapshot.data?.docs;
                                list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList() ??
                                    [];
                                if (list.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: _isSearching
                                          ? _searchlist.length
                                          : list.length,
                                      padding: EdgeInsets.only(top: 10),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ChatUserCard(
                                            user: _isSearching
                                                ? _searchlist[index]
                                                : list[index]);
                                        // return Text('name: ');
                                      });
                                } else {
                                  return Center(
                                    child: Text(
                                      'No Connection Found!',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }
                            }
                          });
                  }
                }),
          )),
    );
  }

  void _adduserDialog() {
    String emaill = '';
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(children: const [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                Text(' Add User')
              ]),
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => emaill = value,
                decoration: InputDecoration(
                  hintText: 'Email Id',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancle',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (emaill.isNotEmpty) {
                      await APIs.addChatUser(emaill).then((value) {
                        if (!value) {
                          Dialogs.showSnackerbar(
                              context, 'User does not Exits!');
                        }
                      });
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}
