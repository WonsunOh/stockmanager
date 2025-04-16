import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmanager/controllers/database_controller.dart';
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
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 15),
                Text(
                  '$content',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '수정 $tlt',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(width: 15),
                Form(
                  key: formKey1,
                  child: Expanded(
                    child: tlt != '입력일'
                    ? TextFormField(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        content = value;
                      },
                    )
                    : Text(DateTime.now().toString()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    if(tlt != '입력일') {
                      DatabaseController.to
                          .updatePiecesGoodsStock(doc, tlt!, content!);
                      DatabaseController.to
                          .updatePiecesGoodsStock(doc, '입력일', DateTime.now().toString());
                    } else {
                      DatabaseController.to
                          .updatePiecesGoodsStock(doc, '입력일', DateTime.now().toString());
                    }



                    Get.to(()=>const GoodsList());
                  },
                  child: const Text('수정'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('나가기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
