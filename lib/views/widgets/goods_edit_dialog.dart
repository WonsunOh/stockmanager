import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/database_controller.dart';
import 'package:stockmanager/models/goods_firebase_model.dart';
import 'package:stockmanager/views/screen/goodsUi/detail_view.dart';
import 'package:stockmanager/views/screen/goodsUi/goods_list.dart';

class GoodsEditDialog {
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  String? tlt;
  String? content;
  String? doc;

  @override
  GoodsEditDialog({this.tlt, this.content, this.doc}) {

    Get.dialog(
      AlertDialog(
        title: Text('$tlt 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  '현재 $tlt',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 15),
                Text(
                  '$content',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '수정 $tlt',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(width: 15),
                Form(
                  key: formKey1,
                  child: Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        content = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    //firestore에 직접 저장하는 방식인데 바로바로 데이터에 반영이 안된다.
                    // await FirebaseFirestore.instance
                    //     .collection('goodsData')
                    //     .doc('${doc}')
                    //     .update({tlt!: content});

                    //model에 저장하는 방식
                    DatabaseController.to
                        .updatePicesGoodsStock(doc, tlt!, content!);
                    Get.to(()=>GoodsList());
                  },
                  child: Text('수정'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('나가기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
