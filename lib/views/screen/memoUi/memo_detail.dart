//상세페이지를 편집화면과 같이 공유한다.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/models/memo_firebase_model.dart';
import 'package:stockmanager/utils/screen_size.dart';
import 'package:stockmanager/views/screen/memoUi/add_memo.dart';
import 'package:stockmanager/views/screen/memoUi/memo_list.dart';
import 'package:stockmanager/views/widgets/memo_edit_dialog.dart';

import '../../../controllers/database_controller.dart';

class MemoDetail extends StatefulWidget {
  MemoDetail({this.memo, Key? key}) : super(key: key);
  final MemoFirebaseModel? memo;
  // int? index;

  @override
  State<MemoDetail> createState() => _MemoDetailState();
}

class _MemoDetailState extends State<MemoDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('메모 상세'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
      ),
      // body: FutureBuilder(
      //     future: FirebaseFirestore.instance.collection('memoData').get(),
      //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //       if (!snapshot.hasData) {
      //         return Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       return Container(
      //         child: Column(
      //           children: [
      //             _detail_body(
      //               '제목',
      //               // doc[widget.index]['title'],
      //               widget.memo!.title!,
      //             ),
      //             _detail_body(
      //               '카테고리',
      //               // doc[widget.index]['category'],
      //               widget.memo!.category!,
      //             ),
      //             _detail_body(
      //               '입력일',
      //               DateFormat('yy.MM.dd')
      //                   .format(DateTime.parse(widget.memo!.inputDay!)),
      //             ),
      //             _detail_body(
      //               '완료율',
      //               widget.memo!.completionRate!,
      //             ),
      //             _detail_body('내용', widget.memo!.content!),
      //             SizedBox(height: ScreenSize.sHeight * 30),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     Get.to(() => AddMemo(
      //                           id: widget.memo!.id!,
      //                         ));
      //                   },
      //                   child: Text('저장'),
      //                 ),
      //                 ElevatedButton(
      //                   onPressed: () {
      //                     Get.back();
      //                   },
      //                   child: Text('나가기'),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //       );
      //     }),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _detail_body(
              '제목',
              widget.memo!.title!,
            ),
            _detail_body(
              '카테고리',
              widget.memo!.category!,
            ),
            _detail_body(
              '입력일',
              DateFormat('yy.MM.dd')
                  .format(DateTime.parse(widget.memo!.inputDay!)),
            ),
            _detail_body(
              '완료율',
              widget.memo!.completionRate!,
            ),
            _detail_body('내용', widget.memo!.content!),
            SizedBox(height: ScreenSize.sHeight * 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.memo != null) {
                        await DatabaseController.to
                            .updateMemo(MemoFirebaseModel(
                          id: widget.memo?.id,
                          title: widget.memo?.title,
                          writer: widget.memo?.writer,
                          inputDay: widget.memo?.inputDay,
                          category: widget.memo?.category,
                          content: widget.memo?.content,
                          completionRate: widget.memo?.completionRate,
                          completionDay: widget.memo?.completionRate == '100'
                              ? DateTime.now().toString()
                              : '',
                        ));
                      }
                    }
                    Get.to(() => MemoList());
                    // Get.to(() => AddMemo(
                    //   id: widget.memo!.id!,
                    // ));
                  },
                  child: Text('저장'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('나가기'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _detail_body(String titl, String content) {
    return GestureDetector(
      onTap: () {
        setState(() {
          MemoEditDialog(tlt: titl, content: content);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: ScreenSize.sHeight * 10,
            horizontal: ScreenSize.sWidth * 10),
        child: titl != '내용'
            ? Row(
                children: [
                  Text(
                    '$titl :',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: content,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      onChanged: (value) {
                        content = value;
                      },
                    ),
                  ),
                  Text(
                    titl != '완료율' ? '' : '%',
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내용',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: double.maxFinite,
                    height: ScreenSize.sHeight * 160,
                    margin: EdgeInsets.symmetric(
                      vertical: ScreenSize.sHeight * 10,
                    ),
                    padding: EdgeInsets.all(ScreenSize.sHeight * 10),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      initialValue: content,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontSize: 15),
                      onChanged: (value) {
                        content = value;
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
