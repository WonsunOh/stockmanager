import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';

import '../../utils/screen_size.dart';

class MemoInputField extends GetView<MemoController> {
  const MemoInputField({
    Key? key,
    required this.title,
    this.fieldController,
    this.child,
    this.memo,
  }) : super(key: key);

  final String title;
  final TextEditingController? fieldController;

  final Widget? child;
  final MemoFirebaseModel? memo;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(builder: (_) {
      // return Container(
      //   margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         title,
      //         style: _titleStyle(),
      //       ),
      //       Container(
      //         alignment: Alignment.center,
      //         width: ScreenSize.sWidth * 0.95,
      //         height: 52,
      //         padding: const EdgeInsets.only(left: 8.0),
      //         margin: const EdgeInsets.only(
      //           top: 5,
      //         ),
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(12),
      //           border: Border.all(width: 1, color: Colors.grey),
      //         ),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: TextFormField(
      //                 style: _titleStyle(),
      //                 obscureText: false,
      //                 autocorrect: false,
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   // hintText: hint,
      //                   // hintStyle: subTitleStyle,
      //                 ),
      //                 controller: fieldController,
      //                 readOnly: child != null ? true : false,
      //               ),
      //             ),
      //             Container(
      //               padding: const EdgeInsets.only(right: 5),
      //               child: child ?? Container(),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // );
      return Container(
        // height: ScreenSize.sHeight * 46,
        // width: ScreenSize.sWidth * 150,
        margin: EdgeInsets.all(ScreenSize.sHeight * 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Text(
              title,
              style: _titleStyle(),
            ),
            Container(
              padding: EdgeInsets.only(left: ScreenSize.sHeight * 10),
              margin: EdgeInsets.only(left: ScreenSize.sWidth * 10),
              height: ScreenSize.sHeight * 46,
              width: ScreenSize.sWidth * 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: _titleStyle(),
                      obscureText: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: fieldController,
                      readOnly: child != null ? true : false,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: child ?? Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _titleStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ScreenSize.sWidth * 15,
    );
  }
}
