import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/views/goods/add_goods_screen.dart';
import 'presentation/views/goods/goods_list_screen.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/views/product/add_product_screen.dart';
import 'presentation/views/product/product_list_screen.dart';

// Supplied via --dart-define at build/run time. See .vscode/launch.json for
// local development and .github/workflows/webapp_pages.yml for CI.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_supabaseUrl.isEmpty || _supabaseAnonKey.isEmpty) {
    throw StateError(
      'SUPABASE_URL and SUPABASE_ANON_KEY must be provided via --dart-define.',
    );
  }

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          '/': (context) => const HomeScreen(),
          '/goodsList': (context) => const GoodsListScreen(),
          '/addGoods': (context) => const AddGoodsScreen(),
          '/productList': (context) => const ProductListScreen(),
          '/addProduct': (context) => const AddProductScreen(),
        },
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
