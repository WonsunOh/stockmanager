import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'presentation/views/goods/add_goods_screen.dart';
import 'presentation/views/goods/goods_list_screen.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/views/memo/add_memo_screen.dart';
import 'presentation/views/memo/memo_list.dart';
import 'presentation/views/product/add_product_screen.dart';
import 'presentation/views/product/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: const FirebaseOptions(
    //   apiKey: 'AIzaSyBgnKjsYA8glr8jQ8oqlhYoYUw0v4BPlEk',
    //   appId: '1:174794732202:web:244ba86eab637d4f22d6d3',
    //   messagingSenderId: '174794732202',
    //   projectId: 'goodsstockmanager',
    // ),
  );

  runApp(
    // ProviderScope로 MyApp을 감싸줍니다.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: '재고관리',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
        '/': (context) => const HomeScreen(), // 기존 MyHome을 HomeScreen으로 변경
        '/goodsList': (context) => const GoodsListScreen(),
        '/addGoods': (context) => const AddGoodsScreen(),
        '/productList':(context) => const ProductListScreen(),
        '/addProduct': (context) => const AddProductScreen(),
        '/memoList': (context) => const MemoListScreen(),
        '/addMemo': (context) => const AddMemoScreen(),
      },

        // localization 선언
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ko', 'KR')],
      ),
    );
  }
}
