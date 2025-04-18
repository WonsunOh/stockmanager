import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'init_binding.dart';
import 'views/screen/goodsUi/goods_list.dart';
import 'views/screen/my_home.dart';

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

  runApp(const MyApp());
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
      child: GetMaterialApp(
        title: '재고관리',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        initialBinding: InitBinding(),
        getPages: [
          // GetPage(name: '/', page: () => AddGoods()),
          GetPage(name: '/', page: () => const MyHome()),
          GetPage(name: '/glist', page: () => const GoodsList()),

        ],

        // localization 선언
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('ko', 'KR'),
        supportedLocales: const [Locale('ko', 'KR')],
      ),
    );
  }
}
