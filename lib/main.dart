import 'package:bookstore/home/view/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemBrown
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
