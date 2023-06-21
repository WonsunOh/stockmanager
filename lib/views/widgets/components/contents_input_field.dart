import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

import '../../../controllers/memo_controller.dart';

class ContentsInputField extends GetView<MemoController> {
  const ContentsInputField({
    Key? key,
    this.memo,
  }) : super(key: key);

  final MemoFirebaseModel? memo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(builder: (_) {
      return SingleChildScrollView(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          initialValue: memo != null ? memo?.content : '',
          decoration: const InputDecoration(
            hintText: '내용 입력',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          maxLines: null,
          onChanged: (val) {
            memo != null ? memo?.content = val : _.contents = val;
            _.update();
          },
        ),
      );
    });
  }
}
