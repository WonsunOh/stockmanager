import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';
import 'package:stockmanager/views/widgets/add_memo.dart';
import 'package:stockmanager/views/widgets/components/goods_price_calculator.dart';

import '../widgets/add_goods.dart';
import 'detail_view.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  var goodData =
      FirebaseFirestore.instance.collection('goodsData').count().get();

  late String networkImgGoods;
  late String networkImgImages;
  String id = '01';
  late String currentGoodsClassify;

  final bgColor = [Colors.lightGreenAccent, Colors.redAccent];
  final txtColor = [
    Colors.red,
    Colors.white,
  ];

  var changeNumber = NumberFormat('###,###,###');

  final List<String> goodsTypeToString = [
    '모든카테고리',
    '과자',
    '사탕',
    '젤리',
    '초콜릿',
    '껌',
    '차,음료',
    '기타',
  ];

  headContainer(
    String title,
    double tltWidth,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      width: tltWidth,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }

  bodyContainer(double boxWidth, String fieldName, double fntSize, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      width: boxWidth,
      height: 30,
      decoration: BoxDecoration(
        color: bgColor[index % bgColor.length],
      ),
      child: Text(
        fieldName,
        style: TextStyle(
          color: txtColor[index % txtColor.length],
          fontSize: fntSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  initState() {
    super.initState();
    currentGoodsClassify = '모든카테고리';

    networkImgImages = 'https://ai.esmplus.com/heeking1/assets/images';
    networkImgGoods = 'https://ai.esmplus.com/heeking1/assets/goods';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              DropdownButton(
                  value: currentGoodsClassify,
                  items: goodsTypeToString.map(
                    (value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      currentGoodsClassify = value!;
                    });
                  }),
              // Text('${goodData.count}'),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => AddMemo());
                },
                icon: Icon(Icons.add_comment)),
            IconButton(
                onPressed: () {
                  // setState(() {
                  //   GoodsPriceCalculator();
                  // });
                  GoodsPriceCalculator();
                },
                icon: Icon(Icons.calculate)),
            IconButton(
              tooltip: '상품정보입력',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return AddGoods();
                    },
                  ),
                );
                print(MediaQuery.of(context).size);
              },
              icon: Icon(Icons.create),
            ),
          ],
        ),

        // 1. collection('datas')/doc('goods')/collection('현재선택된 아이템') 의 자료를 가져온다.
        // 2. snapshot.data.docs.length : 현재 컬렉션의 하위 문서의 길이
        // 3. snapshot.data.docs[index]['id'] : 현재 문서에 해당하는 id를 가져온다.

        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<QuerySnapshot>(
              stream: currentGoodsClassify == '모든카테고리'
                  ? FirebaseFirestore.instance
                      .collection('goodsData')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('goodsData')
                      .where('카테고리', isEqualTo: currentGoodsClassify)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Container(
                  height: double.maxFinite,
                  width: 1000,
                  margin: EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      Text('상품갯수 : ${snapshot.data!.docs.length}'),
                      Row(
                        children: [
                          headContainer('카테고리', 85.0),
                          headContainer('아이템넘버', 85.0),
                          headContainer('상품명', 150.0),
                          headContainer('상품가격(원)', 85.0),
                          headContainer('상품갯수', 85.0),
                          headContainer('개당 가격(원)', 85.0),
                          headContainer('상품무게(g)', 85.0),
                          headContainer('상품재고량', 85.0),
                          headContainer('메모', 250.0),
                        ],
                      ),
                      SizedBox(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        child: ListView.builder(
                            primary: false,
                            // shrinkWrap: false,
                            // scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => DetailView(
                                      index: index,
                                      itemNumber: snapshot.data!.docs[index]
                                          ['아이템 넘버']));
                                },
                                child: Row(
                                  children: [
                                    bodyContainer(
                                        85,
                                        snapshot.data!.docs[index]['카테고리'],
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        snapshot.data!.docs[index]['아이템 넘버'],
                                        16,
                                        index),
                                    bodyContainer(
                                        150,
                                        snapshot.data!.docs[index]['상품명'],
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        changeNumber.format(
                                          int.parse(snapshot.data!.docs[index]
                                              ['상품가격']),
                                        ),
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        snapshot.data!.docs[index]['상품갯수'],
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        (int.parse(snapshot.data?.docs[index]
                                                    ['상품가격']) /
                                                int.parse(snapshot
                                                    .data?.docs[index]['상품갯수']))
                                            .toStringAsFixed(1),
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        changeNumber.format(
                                          int.parse(snapshot.data!.docs[index]
                                              ['상품무게']),
                                        ),
                                        15,
                                        index),
                                    bodyContainer(
                                        85,
                                        snapshot.data!.docs[index]['상품재고'],
                                        15,
                                        index),
                                    bodyContainer(
                                        250,
                                        snapshot.data!.docs[index]['메모'],
                                        15,
                                        index),
                                    // Container(
                                    //   padding:
                                    //       EdgeInsets.symmetric(vertical: 5),
                                    //   alignment: Alignment.center,
                                    //   width: 200,
                                    //   decoration: BoxDecoration(
                                    //     color: bgColor[index % bgColor.length],
                                    //   ),
                                    //   child: Text(
                                    //     '${snapshot.data!.docs[index]['메모']}',
                                    //     style: TextStyle(
                                    //       color:
                                    //           txtColor[index % txtColor.length],
                                    //       fontSize: 15,
                                    //     ),
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              );
                              // Container(
                              //   color: Colors.redAccent,
                              //   margin: EdgeInsets.all(10),
                              //   child: Text('error'));
                            }),
                      ),
                    ],
                  ),
                );
              }),

          // child: StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection('goodsData')
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       }
          //       return SizedBox(
          //         width: double.maxFinite,
          //         // height: double.maxFinite,
          //         child: ListView.builder(
          //           shrinkWrap: true,
          //           scrollDirection: Axis.vertical,
          //           itemCount: snapshot.data?.docs.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return Table(
          //               border: TableBorder.all(),
          //               columnWidths: const <int, TableColumnWidth>{
          //                 0: FixedColumnWidth(100),
          //                 1: FixedColumnWidth(100),
          //                 // 2: FixedColumnWidth(200),
          //                 // 3: FixedColumnWidth(100),
          //                 // 4: FixedColumnWidth(100),
          //                 // 5: FixedColumnWidth(100),
          //                 // 6: FixedColumnWidth(100),
          //               },
          //               children: [
          //                 TableRow(
          //                   children: [
          //                     Container(
          //                       padding: EdgeInsets.symmetric(vertical: 10),
          //                       alignment: Alignment.center,
          //                       child: Text(
          //                         '${snapshot.data?.docs[index]['상품명']}',
          //                         style: TextStyle(
          //                           color: Colors.black,
          //                           fontSize: 15,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       padding: EdgeInsets.symmetric(vertical: 10),
          //                       alignment: Alignment.center,
          //                       child: Text(
          //                         '${snapshot.data?.docs[index]['메모']}',
          //                         style: TextStyle(
          //                           color: Colors.black,
          //                           fontSize: 15,
          //                         ),
          //                       ),
          //                     ),
          //                     // Container(
          //                     //   padding: EdgeInsets.symmetric(vertical: 10),
          //                     //   alignment: Alignment.center,
          //                     //   child: Text(
          //                     //     '${snapshot.data?.docs[index]['상품명']}',
          //                     //     style: TextStyle(
          //                     //       color: Colors.white,
          //                     //       fontSize: 15,
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // Container(
          //                     //   padding: EdgeInsets.symmetric(vertical: 10),
          //                     //   alignment: Alignment.center,
          //                     //   child: Text(
          //                     //     '${snapshot.data?.docs[index]['상품가격']}',
          //                     //     style: TextStyle(
          //                     //       color: Colors.white,
          //                     //       fontSize: 15,
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // Container(
          //                     //   padding: EdgeInsets.symmetric(vertical: 10),
          //                     //   alignment: Alignment.center,
          //                     //   child: Text(
          //                     //     '${snapshot.data?.docs[index]['상품갯수']}',
          //                     //     style: TextStyle(
          //                     //       color: Colors.white,
          //                     //       fontSize: 15,
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // Container(
          //                     //   padding: EdgeInsets.symmetric(vertical: 10),
          //                     //   alignment: Alignment.center,
          //                     //   child: Text(
          //                     //     '${snapshot.data?.docs[index]['상품무게']}',
          //                     //     style: TextStyle(
          //                     //       color: Colors.white,
          //                     //       fontSize: 15,
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // Container(
          //                     //   padding: EdgeInsets.symmetric(vertical: 10),
          //                     //   alignment: Alignment.center,
          //                     //   child: Text(
          //                     //     '${snapshot.data?.docs[index]['메모']}',
          //                     //     style: TextStyle(
          //                     //       color: Colors.white,
          //                     //       fontSize: 15,
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                   ],
          //                 ),
          //               ],
          //             );
          //           },
          //         ),
          //       );
          //     }),

          // child: StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection('goodsData')
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return CircularProgressIndicator();
          //       }
          //       return SizedBox(
          //         width: double.maxFinite,
          //         child: ListView.builder(
          //           scrollDirection: Axis.vertical,
          //           shrinkWrap: true,
          //           itemCount: snapshot.data?.docs.length,
          //           itemBuilder: (BuildContext context, int index) {
          //             return DataTable(
          //               columns: [
          //                 DataColumn(
          //                   label: Container(
          //                     padding: EdgeInsets.symmetric(vertical: 10),
          //                     alignment: Alignment.center,
          //                     child: Text(
          //                       '카테고리',
          //                       style: TextStyle(
          //                         // color: Colors.white,
          //                         fontSize: 15,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 DataColumn(
          //                   label: Container(
          //                     padding: EdgeInsets.symmetric(vertical: 10),
          //                     alignment: Alignment.center,
          //                     child: Text(
          //                       '아이템넘버',
          //                       style: TextStyle(
          //                         // color: Colors.white,
          //                         fontSize: 15,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '상품명',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '상품가격',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '상품갯수',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '개당가격',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '상품무게',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // DataColumn(
          //                 //   label: Container(
          //                 //     padding: EdgeInsets.symmetric(vertical: 10),
          //                 //     alignment: Alignment.center,
          //                 //     child: Text(
          //                 //       '메모',
          //                 //       style: TextStyle(
          //                 //         color: Colors.white,
          //                 //         fontSize: 15,
          //                 //       ),
          //                 //     ),
          //                 //   ),
          //                 // ),
          //               ],
          //               rows: [
          //                 DataRow(
          //                   cells: [
          //                     DataCell(
          //                       Container(
          //                         padding: EdgeInsets.symmetric(vertical: 10),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           '${snapshot.data?.docs[index]['카테고리']}',
          //                           style: TextStyle(
          //                             // color: Colors.white,
          //                             fontSize: 15,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     DataCell(
          //                       Container(
          //                         padding: EdgeInsets.symmetric(vertical: 10),
          //                         alignment: Alignment.center,
          //                         child: Text(
          //                           '${snapshot.data?.docs[index]['아이템 넘버']}',
          //                           style: TextStyle(
          //                             // color: Colors.white,
          //                             fontSize: 15,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${snapshot.data?.docs[index]['상품명']}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${snapshot.data?.docs[index]['상품가격']}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${snapshot.data?.docs[index]['상품갯수']}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${(int.parse(snapshot.data?.docs[index]['상품가격']) / int.parse(snapshot.data?.docs[index]['상품갯수'])).toStringAsFixed(2)}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${snapshot.data?.docs[index]['상품무게']}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                     // DataCell(
          //                     //   Container(
          //                     //     padding: EdgeInsets.symmetric(vertical: 10),
          //                     //     alignment: Alignment.center,
          //                     //     child: Text(
          //                     //       '${snapshot.data?.docs[index]['메모']}',
          //                     //       style: TextStyle(
          //                     //         color: Colors.white,
          //                     //         fontSize: 15,
          //                     //       ),
          //                     //     ),
          //                     //   ),
          //                     // ),
          //                   ],
          //                 ),
          //               ],
          //             );
          //           },
          //         ),
          //       );
          //     }),
        ));
  }

  final oCcy = NumberFormat('#,###', 'ko_KR');
  String caclcPriceToWon(String priceString) {
    return '${oCcy.format(int.parse(priceString))}원';
  }
}
