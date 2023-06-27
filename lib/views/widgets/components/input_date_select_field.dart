import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';
import 'package:stockmanager/utils/screen_size.dart';

import '../../../controllers/memo_controller.dart';

class InputDateSelectField extends GetView<MemoController> {
  const InputDateSelectField({
    Key? key,
    this.memo,
  }) : super(key: key);

  final MemoFirebaseModel? memo;
  @override
  Widget build(BuildContext context) {
    double width = Get.mediaQuery.size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetBuilder<MemoController>(builder: (_) {
          return SizedBox(
            width: ScreenSize.width * 0.3,
            // padding: EdgeInsets.only(left: 35),
            // child: DateTimePicker(
            //   // controller: _.inputDateController,
            //   type: DateTimePickerType.date,
            //   dateMask: 'yyyy년 MM월 dd일(EEEE)',
            //   initialValue: memo != null ? memo?.inputDay.toString() : '',
            //   firstDate: DateTime(2000),
            //   lastDate: DateTime(2100),
            //   locale: const Locale('ko', 'KR'),
            //   // icon: Icon(Icons.event),
            //   // dateLabelText: '    날짜',
            //   decoration: const InputDecoration(
            //     hintText: '작성일 입력',
            //     border: InputBorder.none,
            //   ),
            //
            //   onChanged: (value) {
            //     memo != null
            //         ? memo?.inputDay = value
            //         : _.inputDayChange = value;
            //     _.update();
            //   },
            //   validator: (name) {
            //     return name == null || name.isEmpty ? '클릭하여 날짜를 선택하세요..' : null;
            //   },
            // ),
            child: Text(DateTime.now().toString()),
          );
        }),
      ],
    );
  }
}
