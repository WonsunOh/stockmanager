import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/database/memo_firestore_db.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

class MemoController extends GetxController {
  static MemoController get to => Get.find();
  RxList<MemoFirebaseModel> memoList = RxList<MemoFirebaseModel>();

  var title = '';
  var writer = '작성자';
  var category = '작업분류';
  var contents = '';
  var completionRate = '';
  String completionDay = '';
  String inputDay = DateTime.now().toString();

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
    '아이디어',
    '기타',
  ];

  @override
  void onInit() {
    memoList.bindStream(MemoFirestoreDb.MemoStream());
    super.onInit();
  }
}
