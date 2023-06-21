import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

import '../../../utils/screen_size.dart';

class CompletionRateInputField extends GetView<MemoController> {
  const CompletionRateInputField({
    Key? key,
    this.memo,
  }) : super(key: key);

  final MemoFirebaseModel? memo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(builder: (_) {
      return SizedBox(
        width: ScreenSize.width * 0.35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: TextFormField(
                initialValue: memo != null ? memo?.completionRate : '',
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '완료비율 입력',
                ),
                validator: (name) {
                  return name == null || name.isEmpty ? '완료비율을 입력하세요.' : null;
                },
                onChanged: (value) {
                  memo != null
                      ? memo?.completionRate = value
                      : _.completionRate = value;
                  _.update();
                },
              ),
            ),
            Text(
              '%',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    });
  }
}
