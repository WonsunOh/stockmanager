import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Container(
        child: Text('메모리스트'),
      ),
    );
  }

  addMemoDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('메모입력'),
        content: Container(
          color: Colors.indigo,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: AddMemo()),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('나가기'),
          ),
        ],
      ),
    );
  }
}
