import 'package:flutter/material.dart';

class AddMemo extends StatelessWidget {
  const AddMemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 추가'),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [Text('제목'), Expanded(child: TextFormField()),],
            ),
            Expanded(child: TextFormField())
          ],
        ),
      ),
    );
  }
}
