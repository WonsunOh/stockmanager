import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen_size.dart';

class Utils {
  static boxOutline(String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 46,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth * 30,
            child: Text(
              title,
              style: titleStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenSize.sWidth * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth * 5),
            height: ScreenSize.sHeight * 40,
            width: ScreenSize.width * 0.85,
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

  static boxOutline2(String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 46,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth * 30,
            child: Text(
              title,
              style: titleStyle(),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: ScreenSize.sWidth * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth * 5),
            height: ScreenSize.sHeight * 40,
            width: ScreenSize.width * 0.40,
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

  static boxOutline3(String title, componentWidget) {
    return Container(
      // height: ScreenSize.sHeight * 150,
      // width: ScreenSize.sWidth * 150,
      margin: EdgeInsets.all(ScreenSize.sHeight * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: ScreenSize.sWidth * 30,
            child: Text(
              title,
              style: titleStyle(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: ScreenSize.sWidth * 10),
            margin: EdgeInsets.only(left: ScreenSize.sWidth * 5),
            height: ScreenSize.sHeight * 140,
            width: ScreenSize.width * 0.85,
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

  static titleStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ScreenSize.sWidth * 10,
    );
  }
}
