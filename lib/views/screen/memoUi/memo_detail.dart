import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/utils/screen_size.dart';
import 'package:stockmanager/views/widgets/memo_edit_dialog.dart';

class MemoDetail extends StatefulWidget {
  MemoDetail({required this.index, Key? key}) : super(key: key);
  int? index;

  @override
  State<MemoDetail> createState() => _MemoDetailState();
}

class _MemoDetailState extends State<MemoDetail> {
  String? docs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('메모 상세'),
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [

        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('memoData').get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final doc = snapshot.data.docs;
          return Container(
            child: Column(
              children: [
                _detail_body('제목', doc[widget.index]['title'], doc[widget.index]),
                _detail_body('카테고리', doc[widget.index]['category'], doc[widget.index]),
                _detail_body('입력일', DateFormat('yy.MM.dd').format(DateTime.parse(doc[widget.index]['inputDay'])), doc[widget.index]),
                _detail_body('완료율', doc[widget.index]['completionRate'], doc[widget.index]),
                // _detail_body('내용', snapshot.data.docs[widget.index]['content']),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: ScreenSize.sWidth * 10, top: ScreenSize.sHeight * 10),
                      child: Text(
                        '내용',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          MemoEditDialog(tlt: '내용', content: doc[widget.index]['content'], doc: doc[widget.index]);
                        });
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: ScreenSize.sHeight *160,
                        margin: EdgeInsets.symmetric(vertical: ScreenSize.sHeight * 10, horizontal: ScreenSize.sWidth * 10),
                        padding: EdgeInsets.all(ScreenSize.sHeight * 10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          doc[widget.index]['content'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenSize.sHeight * 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: (){

                          }, child: Text('저장'),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            Get.back();
                          }, child: Text('나가기'),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
    
  }

  _detail_body(String titl, String content, var doc){
    return GestureDetector(
      onTap: (){
        setState(() {
          MemoEditDialog(tlt: titl, content: content, doc: doc);
        });

      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenSize.sHeight * 10, horizontal: ScreenSize.sWidth * 10),
        child: Row(
          children: [
            Text(
              '$titl :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              titl != '완료율' ? content : '$content %',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
