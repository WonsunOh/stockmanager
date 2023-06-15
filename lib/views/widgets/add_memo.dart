import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'memo_dialog.dart';

//이름을 memo_list.dart로 바꿀것.
// 작성한 메모를 listview로 보여줄 것.

class AddMemo extends StatefulWidget {
  const AddMemo({Key? key}) : super(key: key);

  @override
  State<AddMemo> createState() => _AddMemoState();
}

class _AddMemoState extends State<AddMemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 추가'),
        actions: [
          IconButton(
            onPressed: (){
              MemoDialog(); //왜 dialog가 안뜨지?

            },
            icon: Icon(Icons.add),),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text('제목'),
                Expanded(child: TextFormField()),],
            ),
            Expanded(child: TextFormField())
          ],
        ),
      ),
    );
  }
}
