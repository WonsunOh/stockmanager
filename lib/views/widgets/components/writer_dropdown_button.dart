import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

class WriterDropdownButton extends GetView<MemoController> {
  const WriterDropdownButton({
    Key? key,
    this.memo,
  }) : super(key: key);

  final MemoFirebaseModel? memo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(builder: (_) {
      return DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        key: _.nameChoiceKey,
        value: memo != null ? memo!.writer : '작성자',
        items: _.writerName.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        dropdownColor: Colors.white,
        onChanged: (value) {
          memo != null ? memo?.writer = value : _.writer = value!;
          _.update();
        },
        validator: (val) {
          return val == '작성자' ? '작성자를 선택하세요.' : null;
        },
      );
    });
  }
}
