import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockmanager/controllers/database_controller.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';

class AddGoods extends StatefulWidget {
  const AddGoods({Key? key}) : super(key: key);

  @override
  State<AddGoods> createState() => _AddGoodsState();
}

class _AddGoodsState extends State<AddGoods> {
  final _formkey = GlobalKey<FormState>();
  String itemNumber = '';
  String title = '';
  String inputDay = DateTime.now().toString();
  String number = '';
  String price = '';
  String weight = '';
  String stock = '';
  String memo = '';

  final List<String> goodsTypeList = [
    '과자',
    '사탕',
    '젤리',
    '초콜릿',
    '껌',
    '차,음료',
    '기타',
  ];

  late String _selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedValue = '과자';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품추가'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '상품추가',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                //카테고리
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: const Text(
                          '카테고리',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      goodsTypeDropdownButton(),
                    ],
                  ),
                ),
                //상품코드
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품코드',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              itemNumber = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // textFormOutline('상품코드', itemNumber),
                // textFormOutline('상품명', title),
                //상품명
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품명',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // textFormOutline('상품가격', price),

                //입력일
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '입력일',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(inputDay.toString()),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                //상품가격
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품가격',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              price = value;
                            },
                          ),
                        ),
                      ),
                      Text('원'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                // textFormOutline('상품갯수', number),
                //상품갯수
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품갯수',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              number = value;
                            },
                          ),
                        ),
                      ),
                      Text('개'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                // textFormOutline('상품무게', weight),
                //상품무게
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품무게',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              weight = value;
                            },
                          ),
                        ),
                      ),
                      Text('g'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                //상품재고
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          '상품재고량',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              stock = value;
                            },
                          ),
                        ),
                      ),
                      Text('개'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       const Icon(Icons.add_circle),
                //       const SizedBox(width: 10),
                //       const Text(
                //         '개당 가격',
                //         style: TextStyle(
                //           fontSize: 15,
                //           color: Colors.blueGrey,
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       Expanded(
                //         child: Text(
                //           '${(int.parse(price) / int.parse(number)).toStringAsFixed(2)}',
                //           style: TextStyle(
                //             fontSize: 15,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: const Text(
                          'memo',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            memo = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState?.save();
                          await DatabaseController.to
                              .addGoodsStock(GoodsFirebaseModel(
                            category: _selectedValue,
                            itemNumber: itemNumber,
                            title: title,
                            inputDay: inputDay.toString(),
                            number: number,
                            price: price,
                            weight: weight,
                            stock: stock,
                            memo: memo,
                          ));
                        } else {
                          Get.snackbar(
                            '입력에러',
                            '입력항목을 확인하세요.',
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.amber,
                            colorText: Colors.black,
                          );
                        }
                        _formkey.currentState?.reset();
                        Get.toNamed('/');
                      },
                      child: Text('저장'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  goodsTypeDropdownButton() {
    return DropdownButton(
      value: _selectedValue,
      items: goodsTypeList.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedValue = value!;
        });
      },
    );
  }

  textFormOutline(String titl, String val) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.add_circle),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: Text(
              titl,
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: TextFormField(
                onChanged: (value) {
                  val = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
