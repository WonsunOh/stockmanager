import 'package:get/get.dart';

class MemoController extends GetxController {
  static MemoController get to => Get.find();

  var title = '';
  var writer = '오원선';
  var category = '코스트고 작업';
  var contents = '';

  //add_memo.dart
  final List<String> writerName = [
    '오원선',
    '왕희경',
  ];

  final List<String> memoCategory = [
    '코스트고 작업',
    '기타',
  ];
}
