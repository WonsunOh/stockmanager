import 'package:flutter/material.dart';
import 'package:get/get.dart';

//메모입력창
//제목/날짜/내용 입력창
//입력 후 database에 저장할 것. - memo_firebase_model.dart를 만든 후 저장.

class MemoDialog{
  void Memodialog(){
    Get.dialog(
      AlertDialog(
        title: Text('메모입력'),
        content: Column(
          children: [
            Row(
              children: [
                Text('제목'), Expanded(child: TextFormField()),
              ],
            ),
            Row(
              children: [
                Text('작성일'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
