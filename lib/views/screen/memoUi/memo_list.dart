import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/memo_controller.dart';
import 'package:stockmanager/utils/screen_size.dart';

import 'add_memo.dart';
import 'memo_detail.dart';

class MemoList extends StatefulWidget {
  const MemoList({Key? key}) : super(key: key);

  @override
  State<MemoList> createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('메모'),
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/');
          },
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => AddMemo());
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: MemoController.to.memoList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(() => MemoDetail(
                        memo: MemoController.to.memoList[index],
                      ));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenSize.sWidth * 10,
                      vertical: ScreenSize.sHeight * 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4.0,
                    color: Color(0xffb9e29b),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.sWidth * 10,
                          vertical: ScreenSize.sHeight * 5),
                      height: ScreenSize.sHeight * 200,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: ScreenSize.sHeight * 50,
                                    child: Text(
                                      MemoController.to.memoList[index].title!,
                                      style: TextStyle(
                                        fontSize: ScreenSize.sWidth * 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenSize.sHeight * 5),
                                  SizedBox(
                                    height: ScreenSize.sHeight * 35,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time_filled_rounded,
                                          color: Colors.grey,
                                          size: ScreenSize.sWidth * 15,
                                        ),
                                        SizedBox(width: 4),
                                        // Text(
                                        //   '${DateTime.parse(snapshot.data!.docs[index]['inputDay'].toString())}',
                                        //   style: TextStyle(
                                        //     fontSize: ScreenSize.sWidth * 9,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.redAccent,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: ScreenSize.sHeight * 5),
                                  SizedBox(
                                    height: ScreenSize.sHeight * 65,
                                    child: Text(
                                      MemoController
                                          .to.memoList[index].content!,
                                      style: TextStyle(
                                        fontSize: ScreenSize.sWidth * 12,
                                        color: Colors.redAccent,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  SizedBox(height: ScreenSize.sHeight * 5),
                                  Tooltip(
                                    message:
                                        '완성비율은 ${MemoController.to.memoList[index].completionRate!}%',
                                    child: Container(
                                      height: ScreenSize.sHeight * 5,
                                      width: double.maxFinite,
                                      color: Colors.indigo,
                                      margin: EdgeInsets.symmetric(
                                          vertical: ScreenSize.sHeight * 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: int.parse(MemoController
                                                .to
                                                .memoList[index]
                                                .completionRate!),
                                            child: Container(
                                              height: ScreenSize.sHeight * 5,
                                              width: 150,
                                              // width: double.maxFinite * 0.5,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 100 -
                                                int.parse(MemoController
                                                    .to
                                                    .memoList[index]
                                                    .completionRate!),
                                            child: Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ScreenSize.sWidth * 10),
                            height: ScreenSize.sHeight * 150,
                            width: ScreenSize.sWidth * 0.5,
                            color: Colors.redAccent.withOpacity(0.7),
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              MemoController.to.memoList[index].category!,
                              style: TextStyle(
                                fontSize: ScreenSize.sWidth * 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              // return Container(
              //   padding: EdgeInsets.symmetric(horizontal: ScreenSize.sWidth * 20),
              //   width: ScreenSize.sWidth,
              //   margin: EdgeInsets.only(bottom: ScreenSize.height * 12),
              //   child: Container(
              //     padding: EdgeInsets.all(ScreenSize.sWidth * 16),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(8),
              //       color: Color(0xffb9e29b),
              //     ),
              //     child: Row(
              //       children: [
              //         Expanded(child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(snapshot.data!.docs[index]['title'], style: TextStyle(
              //               fontSize: ScreenSize.sWidth * 16, fontWeight: FontWeight.bold, color: Colors.redAccent,
              //             ),),
              //             SizedBox(height: ScreenSize.sHeight * 12),
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Icon(Icons.access_time_filled_rounded, color: Colors.grey, size: ScreenSize.sWidth * 18,),
              //                   SizedBox(width: 4),
              //                   Text(snapshot.data!.docs[index]['inputDay'].toString(), style: TextStyle(
              //                     fontSize: ScreenSize.sWidth * 10, fontWeight: FontWeight.bold, color: Colors.redAccent,
              //                   ),),
              //
              //
              //                 ],
              //
              //
              //             ),
              //             SizedBox(height: 12),
              //             Text(snapshot.data!.docs[index]['content'], style: TextStyle(
              //               fontSize: ScreenSize.sWidth * 16, fontWeight: FontWeight.bold, color: Colors.redAccent,
              //             ),),
              //           ],
              //         ),),

              //       ],
              //     ),
              //   ),
              // );
            },
          ),
        ),
      ),
    );
  }
}
