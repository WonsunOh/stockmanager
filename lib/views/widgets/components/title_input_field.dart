import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

import '../../../utils/screen_size.dart';

class TitleInputField extends GetView<MemoController> {
  const TitleInputField({
    Key? key,
    this.memo,
  }) : super(key: key);

  final MemoFirebaseModel? memo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(builder: (_) {
      return SizedBox(
        width: ScreenSize.width * 0.55,
        child: TextFormField(
          initialValue: memo != null ? memo?.title : '',
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '제목 입력',
          ),
          validator: (name) {
            return name == null || name.isEmpty ? '제목을 입력하세요.' : null;
          },
          onChanged: (value) {
            memo != null ? memo?.title = value : _.title = value;
            _.update();
          },
        ),
      );
    });
  }
}
