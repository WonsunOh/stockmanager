import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/goods_firebase_model.dart';
import '../widgets/goods_edit_dialog.dart';
import 'item_indicator.dart';

class DetailView extends StatefulWidget {
  final int index;
  final String itemNumber;
  DetailView({
    Key? key,
    required this.index,
    required this.itemNumber,
  }) : super(key: key);

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 상세'),
        actions: [
          IconButton(
            tooltip: '무료배송 상세',
            onPressed: () {
              // print('$currentCollection,$index,$id');
            },
            icon: Icon(Icons.navigate_next),
          ),
        ],
      ),
      body: FutureBuilder<Object>(
          future: FirebaseFirestore.instance
              .collection('goodsData')
              .doc('${widget.itemNumber}')
              .get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    datail_body(
                      '상품명',
                      snapshot.data['상품명'],
                      snapshot.data['아이템 넘버'],
                    ),
                    SizedBox(height: 10),
                    datail_body(
                        '카테고리', snapshot.data['카테고리'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body('아이템번호', snapshot.data['아이템 넘버'],
                        snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '상품가격', snapshot.data['상품가격'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '상품갯수', snapshot.data['상품갯수'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '상품무게', snapshot.data['상품무게'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '개당 가격',
                        (int.parse(snapshot.data['상품가격']) /
                                int.parse(snapshot.data['상품갯수']))
                            .toStringAsFixed(1),
                        snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '개당 무게',
                        (int.parse(snapshot.data['상품무게']) /
                                int.parse(snapshot.data['상품갯수']))
                            .toStringAsFixed(1),
                        snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '상품재고', snapshot.data['상품재고'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                    datail_body(
                        '메모', snapshot.data['메모'], snapshot.data['아이템 넘버']),
                    SizedBox(height: 10),
                  ],
                ),
              ));
            } else {
              CircularProgressIndicator();
            }

            return Center(
              child: Text('데이터 오류'),
            );
          }),
    );
  }

  datail_body(
    String titl,
    String content,
    String doc,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          GoodsEditDialog(tlt: titl, content: content, doc: doc);
        });
      },
      child: Row(
        children: [
          Text(
            titl,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(width: 20),
          Text(
            content,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
