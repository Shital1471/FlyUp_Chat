import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_up/APIS/apis.dart';
import 'package:fly_up/Screen/viewProfileScreen.dart';
import 'package:fly_up/helper/my_date_util.dart';
import 'package:fly_up/modules/chat_user.dart';
import 'package:fly_up/modules/messages.dart';
import 'package:fly_up/widgets/message_card.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textedtingcontroller = TextEditingController();
  bool _showemoji = false, _isUploding = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showemoji) {
              setState(() => _showemoji = !_showemoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APIs.getAllMessage(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                              child: SizedBox(),
                            );
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding: EdgeInsets.only(top: 10),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MesssageCard(
                                      message: _list[index],
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text(
                                  'Say Hii! 👋',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }
                        }
                      }),
                ),
                if (_isUploding)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                _chatInput(),
                if (_showemoji)
                  SizedBox(
                    height: nq.height * 0.35,
                    child: EmojiPicker(
                      textEditingController: _textedtingcontroller,
                      config: Config(
                        columns: 8,
                        emojiSizeMax: 32 *
                            (Platform.isIOS
                                ? 1.30
                                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
            stream: APIs.getuserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(nq.height * .03),
                    child: CachedNetworkImage(
                      width: nq.height * .055,
                      height: nq.height * .055,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        list.isNotEmpty ? list[0].name : widget.user.name,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? "Online"
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              );
            }));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: nq.height * .01, horizontal: nq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Row(children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showemoji = !_showemoji);
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    )),
                Expanded(
                  child: TextField(
                    controller: _textedtingcontroller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showemoji) setState(() => _showemoji = !_showemoji);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type Something... ',
                      hintStyle: TextStyle(
                        color: Colors.blueAccent,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // Pick image from gallery button
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        log("image path: {$i.path}");
                        setState(() {
                          _isUploding = true;
                        });
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          _isUploding = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 25,
                    )),
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log("image path: {$image.path}");
                        setState(() {
                          _isUploding = true;
                        });
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() {
                          _isUploding = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 25,
                    )),
                SizedBox(
                  width: nq.width * .02,
                )
              ]),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textedtingcontroller.text.isNotEmpty) {
               if(_list.isEmpty){
                 APIs.sendFirstMessage(
                      widget.user, _textedtingcontroller.text, Type.text);
               }
               else{
                 APIs.sendMessage(
                      widget.user, _textedtingcontroller.text, Type.text);
               }
                 _textedtingcontroller.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
