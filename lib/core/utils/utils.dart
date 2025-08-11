import 'package:flutter/material.dart';

import 'screen_size.dart';

class Utils {
  static boxOutline(BuildContext context, String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 46,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight(context) * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth(context) * 50,
            child: Text(
              title,
              style: titleStyle(context),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenSize.sWidth(context) * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth(context) * 5),
            height: ScreenSize.sHeight(context) * 60,
            width: ScreenSize.width(context) * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: componentWidget,
          ),
        ],
      ),
    );
  }

  static boxOutline2(BuildContext context,String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 46,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight(context) * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth(context) * 50,
            child: Text(
              title,
              style: titleStyle(context),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: ScreenSize.sWidth(context) * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth(context) * 5),
            height: ScreenSize.sHeight(context) * 60,
            width: ScreenSize.width(context) * 0.50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: componentWidget,
          ),
        ],
      ),
    );
  }

  static boxOutline3(BuildContext context,String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 150,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight(context) * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth(context) * 50,
            child: Text(
              title,
              style: titleStyle(context),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenSize.sWidth(context) * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth(context) * 5),
            height: ScreenSize.sHeight(context) * 160,
            width: ScreenSize.width(context) * 0.75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: componentWidget,
          ),
        ],
      ),
    );
  }

  static titleStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ScreenSize.sWidth(context) * 12,
    );
  }
}
