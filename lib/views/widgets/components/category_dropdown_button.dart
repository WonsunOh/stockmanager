import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

class CategoryDropdownButton extends GetView<MemoController> {
  const CategoryDropdownButton({
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
        key: _.sortChoiceKey,
        value: memo != null ? memo!.category : '작업분류',
        items: _.memoCategory.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          memo != null ? memo?.category = value : _.category = value!;
          _.update();
        },
        validator: (val) {
          return val == '작업분류' ? '분류값을 선택하세요.' : null;
        },
      );
    });
  }
}
