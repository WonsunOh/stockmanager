import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('memoData').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Row(
                children: [Text(snapshot.data!.docs[index]['title'])],
              );
            },
          );
        },
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
