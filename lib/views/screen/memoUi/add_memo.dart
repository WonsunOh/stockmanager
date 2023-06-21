import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/database_controller.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';
import 'package:stockmanager/utils/utils.dart';
import 'package:stockmanager/views/screen/memoUi/memo_list.dart';
import 'package:stockmanager/views/widgets/components/title_input_field.dart';
import 'package:stockmanager/views/widgets/memo_input_field.dart';

import '../../../utils/screen_size.dart';
import '../../widgets/components/category_dropdown_button.dart';
import '../../widgets/components/completion_rate_input_field.dart';
import '../../widgets/components/contents_input_field.dart';
import '../../widgets/components/input_date_select_field.dart';
import '../../widgets/components/writer_dropdown_button.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: ScreenSize.sHeight * 30),
            Utils.boxOutline('제목', TitleInputField(memo: widget.memo)),
            Utils.boxOutline2('작성자', WriterDropdownButton(memo: widget.memo)),
            Utils.boxOutline2('작성일', InputDateSelectField(memo: widget.memo)),
            Utils.boxOutline2('분류', CategoryDropdownButton(memo: widget.memo)),
            Utils.boxOutline3('내용', ContentsInputField(memo: widget.memo)),
            Utils.boxOutline2(
                '완료율', CompletionRateInputField(memo: widget.memo)),
            SizedBox(height: ScreenSize.sHeight * 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<MemoController>(builder: (_) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        if (widget.memo != null) {
                          await DatabaseController.to
                              .updateMemo(MemoFirebaseModel(
                            id: widget.id,
                            title: widget.memo?.title,
                            writer: widget.memo?.writer,
                            inputDay: widget.memo?.inputDay,
                            category: widget.memo?.category,
                            content: widget.memo?.content,
                            completionRate: widget.memo?.completionRate,
                            completionDay: widget.memo?.completionRate == '100'
                                ? DateTime.now()
                                : DateTime.parse(_.completionDay),
                          ));
                        } else {
                          await DatabaseController.to.addMemo(MemoFirebaseModel(
                            title: _.title,
                            writer: _.writer,
                            inputDay: DateTime.parse(_.inputDayChange),
                            category: _.category,
                            content: _.contents,
                            completionRate: _.completionRate,
                            // completionDay: widget.memo?.completionRate == '100'
                            //     ? DateTime.now()
                            //     : DateTime.parse(_.completionDay),
                          ));
                        }
                        Get.to(() => MemoList());
                      } else {
                        Get.snackbar(
                          '입력에러',
                          '입력항목을 확인하세요.',
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.amber,
                          colorText: Colors.black,
                        );
                      }
                      _formKey.currentState?.reset();
                    },
                    child: Text('저장', style: Utils.titleStyle(),),
                  );
                }),
                SizedBox(width: ScreenSize.sWidth * 15),
                // widget.memo == null
                //     ? GetBuilder<MemoController>(builder: (_) {
                //         return ElevatedButton(
                //           onPressed: () async {
                //             if (_formKey.currentState!.validate()) {
                //               _formKey.currentState?.save();
                //               await DatabaseController.to.addMemo(widget.memo!);
                //               // await DatabaseController.to
                //               //     .addMemo(MemoFirebaseModel(
                //               //   title: _.title,
                //               //   writer: _.writer,
                //               //   inputDay: DateTime.parse(_.inputDayChange),
                //               //   category: _.category,
                //               //   content: _.contents,
                //               //   completionRate: _.completionRate,
                //               //   completionDay:
                //               //       widget.memo?.completionRate == '100'
                //               //           ? DateTime.now()
                //               //           : DateTime.parse(_.completionDay),
                //               // ));
                //             } else {
                //               Get.snackbar(
                //                 '입력에러',
                //                 '입력항목을 확인하세요.',
                //                 duration: const Duration(seconds: 2),
                //                 backgroundColor: Colors.amber,
                //                 colorText: Colors.black,
                //               );
                //             }
                //             _formKey.currentState?.reset();
                //           },
                //           child: Text('계속입력'),
                //         );
                //       })
                //     : const SizedBox(width: 0),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('나가기', style: Utils.titleStyle(),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
