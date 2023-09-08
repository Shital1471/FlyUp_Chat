import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fly_up/helper/my_date_util.dart';
import 'package:fly_up/modules/messages.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../APIS/apis.dart';
import '../helper/dialogs.dart';
import '../main.dart';

class MesssageCard extends StatefulWidget {
  final Message message;
  const MesssageCard({super.key, required this.message});

  @override
  State<MesssageCard> createState() => _MesssageCardState();
}

class _MesssageCardState extends State<MesssageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenmessage() : _bluemessage(),
    );
  }

  Widget _bluemessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? nq.width * .03
                : nq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: nq.width * .04, vertical: nq.height * .01),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(nq.height * .03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: nq.width * .04),
          child: Text(
            MyDateUtil.getformattedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        )
      ],
    );
  }

  Widget _greenmessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: nq.width * .04,
        ),
        if (widget.message.read.isNotEmpty)
          const Icon(
            Icons.done_all_rounded,
            color: Colors.blue,
            size: 20,
          ),
        const SizedBox(
          width: 2,
        ),
        Text(
          MyDateUtil.getformattedTime(
              context: context, time: widget.message.sent),
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? nq.width * .03
                : nq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: nq.width * .04, vertical: nq.height * .01),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(nq.height * .03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isme) {
    showModalBottomSheet(
        
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: nq.height * .015, horizontal: nq.width * .4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 28,
                      ),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dialogs.showSnackerbar(context, "Text Copied");
                        });
                      },
                    )
                  : _OptionItem(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue,
                        size: 28,
                      ),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image URl: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'Fly_Up')
                              .then((success) {
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSnackerbar(
                                  context, "Image Successfully Saved!");
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg $e');
                        }
                      },
                    ),
              if (isme)
                Divider(
                  color: Colors.black54,
                  endIndent: nq.width * .04,
                  indent: nq.width * .04,
                ),
              if (widget.message.type == Type.text && isme)
                _OptionItem(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.blue,
                    size: 28,
                  ),
                  name: 'Edit Message',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessageUpdateDialog();
                  },
                ),
              if (isme)
                _OptionItem(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 28,
                  ),
                  name: 'Delete Message',
                  onTap: () async {
                    await APIs.deleteMessage(widget.message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
              Divider(
                color: Colors.black54,
                endIndent: nq.width * .04,
                indent: nq.width * .04,
              ),
              _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.blue,
                ),
                name:
                    'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.red,
                ),
                name: widget.message.read.isEmpty
                    ? "Read At: Not seen Yet"
                    : "Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}",
                onTap: () {},
              ),
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updateMsg = widget.message.msg;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Row(children: const [
                Icon(
                  Icons.message,
                  color: Colors.blue,
                ),
                Text('Update Message')
              ]),
              content: TextFormField(
                initialValue: updateMsg,
                maxLines: null,
                onChanged: (value) => updateMsg = value,
                decoration: InputDecoration(
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
                  onPressed: () {
                    Navigator.pop(context);
                    APIs.updateMessage(widget.message, updateMsg);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        icon,
        Padding(
          padding: EdgeInsets.only(
              top: nq.height * .015,
              left: nq.width * .05,
              bottom: nq.height * .015),
          child: Text(
            '   $name',
            style: TextStyle(
            fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
          ),
        )
      ]),
    );
  }
}
