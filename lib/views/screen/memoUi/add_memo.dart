import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';
import 'package:stockmanager/utils/utils.dart';
import 'package:stockmanager/views/widgets/components/title_input_field.dart';
import 'package:stockmanager/views/widgets/memo_input_field.dart';

import '../../../utils/screen_size.dart';

//이름을 memo_list.dart로 바꿀것.
// 작성한 메모를 listview로 보여줄 것.

class AddMemo extends StatefulWidget {
  AddMemo({
    Key? key,
    this.id,
    this.memo,
  }) : super(key: key);

  final int? id;
  final MemoFirebaseModel? memo;

  @override
  State<AddMemo> createState() => _AddMemoState();
}

class _AddMemoState extends State<AddMemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.id == null ? '메모 입력' : '메모 편집',
          style: TextStyle(
            fontSize: ScreenSize.sWidth * 15,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Utils.boxOutline('제목', TitleInputField(memo: widget.memo)),
          Utils.boxOutline2('작성자', TitleInputField(memo: widget.memo)),
          Utils.boxOutline2('작성일', TitleInputField(memo: widget.memo)),
          Utils.boxOutline2('분류', TitleInputField(memo: widget.memo)),
        ],
      ),
    );
  }
}
