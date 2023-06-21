import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/utils/screen_size.dart';

import 'add_memo.dart';

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
        title: const Text('메모'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('memoData').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: ScreenSize.sWidth * 10, vertical: ScreenSize.sHeight * 5),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 4.0,
                      color: Color(0xffb9e29b),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data?.docs[index]['title'], style: TextStyle(
                                            fontSize: ScreenSize.sWidth * 16, fontWeight: FontWeight.bold, color: Colors.redAccent,
                                          ),),
                                SizedBox(height: ScreenSize.sHeight * 12),
                                Text(snapshot.data?.docs[index]['content'], style: TextStyle(
                                  fontSize: ScreenSize.sWidth * 10, color: Colors.redAccent,
                                ),),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: ScreenSize.sWidth *10),
                            height: ScreenSize.sHeight *60,
                            width: ScreenSize.sWidth *0.5,
                            color: Colors.redAccent!.withOpacity(0.7),
                          ),
                          RotatedBox(quarterTurns: 3,
                            child: Text(
                              snapshot.data!.docs[index]['category'], style: TextStyle(
                              fontSize: ScreenSize.sWidth * 10, fontWeight: FontWeight.bold, color: Colors.redAccent,
                            ),
                            ),
                          ),
                        ],

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
            );
          },
        ),
      ),
    );
  }


}
