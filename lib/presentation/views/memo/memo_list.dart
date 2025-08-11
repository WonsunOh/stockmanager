import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/screen_size.dart';
import '../../viewmodels/memo_list_viewmodel.dart';

class MemoListScreen extends ConsumerWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoListState = ref.watch(memoListViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('메모'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context,'/');
          },
          icon: Icon(Icons.home),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context,'/addMemo');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: memoListState.when(
        data: (memos) {
          if (memos.isEmpty) {
            return const Center(child: Text('작성된 메모가 없습니다.'));
          }
          return ListView.builder(
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];
              return GestureDetector(
                onTap: () {
                  // Get.to(() => MemoDetail(
                  //       // index: index,
                  //       memo: MemoController.to.memoList[index],
                  //     )); 
                  //TODO. MemoDetail도 수정 필요
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: ScreenSize.sWidth(context) * 10,
                      vertical: ScreenSize.sHeight(context) * 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4.0,
                    color: Color(0xffb9e29b),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenSize.sWidth(context) * 10,
                          vertical: ScreenSize.sHeight(context) * 5),
                      height: ScreenSize.sHeight(context) * 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: ScreenSize.sHeight(context) * 50,
                                  child: Text(
                                    memo.title!,
                                    style: TextStyle(
                                      fontSize: ScreenSize.sWidth(context) * 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                                SizedBox(height: ScreenSize.sHeight(context) * 5),
                                SizedBox(
                                  height: ScreenSize.sHeight(context) * 35,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled_rounded,
                                        color: Colors.grey,
                                        size: ScreenSize.sWidth(context) * 15,
                                      ),
                                      SizedBox(width: 4),
                                      
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenSize.sHeight(context) * 5),
                                SizedBox(
                                  height: ScreenSize.sHeight(context) * 65,
                                  child: Text(
                                    memo.content!,
                                    style: TextStyle(
                                      fontSize: ScreenSize.sWidth(context) * 12,
                                      color: Colors.redAccent,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(height: ScreenSize.sHeight(context) * 5),
                                Tooltip(
                                  message:
                                      '완성비율은 ${memo.completionRate!}%',
                                  child: Container(
                                    height: ScreenSize.sHeight(context) * 5,
                                    width: double.maxFinite,
                                    color: Colors.indigo,
                                    margin: EdgeInsets.symmetric(
                                        vertical: ScreenSize.sHeight(context) * 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: int.parse(memo.completionRate!),
                                          child: Container(
                                            height: ScreenSize.sHeight(context) * 5,
                                            width: 150,
                                            // width: double.maxFinite * 0.5,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100 -
                                              int.parse(memo.completionRate!),
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ScreenSize.sWidth(context) * 10),
                            height: ScreenSize.sHeight(context) * 150,
                            width: ScreenSize.sWidth(context) * 0.5,
                            color: Colors.redAccent.withOpacity(0.7),
                          ),
                          RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              memo.category!,
                              style: TextStyle(
                                fontSize: ScreenSize.sWidth(context) * 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              
            },
          );
        },
         // 로딩 중일 때
        loading: () => const Center(child: CircularProgressIndicator()),
        // 에러가 발생했을 때
        error: (err, stack) => Center(child: Text('에러가 발생했습니다: $err')),
      ),
    );
  }
}
