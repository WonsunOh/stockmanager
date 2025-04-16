import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final goodsData = FirebaseFirestore.instance.collection('goodsData');
  GoodsFirebaseModel? goodsModel;

  final _formkey1 = GlobalKey<FormState>();
  final _controll = TextEditingController();
  String itemNumber = '';
  String p_itemNumber = '';
  String p_title = '';
  String p_number = '';
  String p_price = '';
  String earningRate = '';
  String commissionRate = '';
  String p_stock = '';
  String p_memo = '';

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
        title: const Text('제품추가'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Form(
            key: _formkey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text(
                    '제품추가',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                //카테고리
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '카테고리',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      productTypeDropdownButton(),
                    ],
                  ),
                ),
                //상품코드
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '제품코드',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              p_itemNumber = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      //연관상품코드 - goodsData 컬렉션에 있는 코드와 현 제품의 코드를 매치시킨다.
                      // 현 제품의 이름으로 자동완성 검색창을 띄운 후 선택하면 상품 코드가 뜨게
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '연관상품코드',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: goodsData.snapshots(),
                            builder: (context, snapshot) {
                              final List<DropdownMenuItem> goodsDropdownItems = [];
                              if(!snapshot.hasData){

                                return const CircularProgressIndicator();

                                } else {

                                final items = snapshot.data?.docs;
                                for (int i=0; i<items!.length; i++) {
                                  var snap = snapshot.data?.docs[i];
                                  goodsDropdownItems.add(
                                    DropdownMenuItem(
                                      value: snap,
                                      child: Text('$snap'),
                                    ),
                                  );
                                }
                              }
                              String? itemValue = snapshot.data?.docs[0].toString();

                              return DropdownButton(
                                value: snapshot.data?.docs[0],
                                items: goodsDropdownItems,
                                onChanged: (value) {
                                  // setState(() {
                                  //   _itemValue = value;
                                  // });

                                },
                              );
                            }
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                // textFormOutline('상품코드', itemNumber),
                // textFormOutline('상품명', title),
                //상품명
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '제품명',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              p_title = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //원료갯수
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '원료의 갯수',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              p_number = value;
                            },
                          ),
                        ),
                      ),
                      const Text('개'),
                      const SizedBox(width: 10),
                      const SizedBox(width: 30),
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '개당 원가',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 100,
                        // child: Text((int.parse(goodsModel!.price!) /
                        //         int.parse(goodsModel!.number!))
                        //     .toStringAsFixed(1)),
                      ),
                      const Text('원'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                // textFormOutline('상품가격', price),
                //상품가격
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '제품판매가격',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              p_price = value;
                            },
                          ),
                        ),
                      ),
                      const Text('원'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                //수수료율
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '수수료율',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              commissionRate = value;
                            },
                          ),
                        ),
                      ),
                      const Text('%'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                //수익률
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
                          '수익률',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              earningRate = value;
                            },
                          ),
                        ),
                      ),
                      const Text('%'),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                //상품재고
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
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
                          margin: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            onChanged: (value) {
                              p_stock = value;
                            },
                          ),
                        ),
                      ),
                      const Text('개'),
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
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 90,
                        child: Text(
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
                            p_memo = value;
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
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey1.currentState!.validate()) {
                          _formkey1.currentState?.save();
                          // await DatabaseController.to
                          //     .addGoodsStock(GoodsFirebaseModel(
                          //   category: _selectedValue,
                          //   itemNumber: itemNumber,
                          //   title: title,
                          //   number: number,
                          //   price: price,
                          //   weight: weight,
                          //   stock: stock,
                          //   memo: memo,
                          // ));
                        } else {
                          Get.snackbar(
                            '입력에러',
                            '입력항목을 확인하세요.',
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.amber,
                            colorText: Colors.black,
                          );
                        }
                        _formkey1.currentState?.reset();
                        Get.toNamed('/');
                      },
                      child: const Text('저장'),
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

  productTypeDropdownButton() {
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
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.add_circle),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: Text(
              titl,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
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
