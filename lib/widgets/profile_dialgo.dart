import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fly_up/Screen/viewProfileScreen.dart';
import 'package:fly_up/modules/chat_user.dart';

import '../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: nq.width * .6,
        height: nq.height * .35,
        child: Stack(
          children: [
            Positioned(
              top: nq.height * .075,
              left: nq.width * .1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(nq.height * .25),
                child: CachedNetworkImage(
                  width: nq.width * 0.5,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
                left: nq.width * .04,
                top: nq.height * .02,
                width: nq.width * .55,
                child: Text(
                  user.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
            Positioned(
                right: 8,
                top: 6,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProfileScreen(user: user)));
                  },
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 30,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
