
// 사이즈 1 대비 스크린 비율
import 'package:flutter/material.dart';

class ScreenSize {
  // BuildContext를 인자로 받아 화면 너비를 반환하는 메서드
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // BuildContext를 인자로 받아 화면 높이를 반환하는 메서드
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 기존 sWidth, sHeight도 메서드로 변경
  static double sWidth(BuildContext context) {
    return width(context) * 0.0026;
  }
  
  static double sHeight(BuildContext context) {
    return height(context) * 0.0012;
  }
}