import 'dart:io';

import 'package:flutter/material.dart';

class Styles {
  late BuildContext context;
  late double deviceWidth;

  // Initalizer
  Styles(this.context) {
    deviceWidth = MediaQuery.of(context).size.width;
  }

// Appbar needs title
  AppBar appBar(BuildContext context, String pageName,
      {IconData icon = Icons.arrow_back_ios_new}) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              exit(0);
            }
          },
          icon: Icon(icon),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          pageName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
    );
  }

  //Need icon & onPress
  Padding floatingButton(IconData icon, Function() onPress) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 30),
      child: FloatingActionButton(
        elevation: 0,
        onPressed: onPress,
        child: Icon(
          icon,
          size: 32,
        ),
      ),
    );
  }

  TextField inputField(String label, TextEditingController controller,
      FocusNode node, double fontSize) {
    return TextField(
      autofocus: true,
      controller: controller,
      focusNode: node,
      decoration: InputDecoration(
          labelText: ' $label ',
          labelStyle:
              TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Container tileBox(
      Widget leading, String label, String subText, Widget trailing) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 2)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 6,
          right: 10,
        ),
        leading: leading,
        title: Wrap(children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            subText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
