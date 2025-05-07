import 'package:flutter/material.dart';

import '../utils/dimensions.dart';


class ChatCard extends StatelessWidget {
  final String senderName;
  final String senderEmail;
  final String content;

  const ChatCard({
    Key? key,
    required this.senderName,
    required this.senderEmail,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Container(
        alignment: Alignment.centerLeft,
        width: Dimensions.screenWidth,
        height: Dimensions.height10 * 9.5,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius10),
          border: Border.all(color: Theme.of(context).highlightColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderName,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              senderEmail,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).dividerColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}