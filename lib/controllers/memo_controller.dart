import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemoController extends GetxController {
  static MemoController get to => Get.find();

  var title = '';
  var writer = '작성자';
  var category = '작업분류';
  var contents = '';
  var completionRate = '';
  String completionDay = '';
  String inputDayChange = '';

  GlobalKey<FormState> nameChoiceKey = GlobalKey<FormState>();
  GlobalKey<FormState> sortChoiceKey = GlobalKey<FormState>();

  //add_memo.dart
  final List<String> writerName = [
    '작성자',
    '오원선',
    '왕희경',
  ];

  final List<String> memoCategory = [
    '작업분류',
    '코스트고 작업',
    '기타',
  ];
}
