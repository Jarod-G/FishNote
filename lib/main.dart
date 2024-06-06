import 'package:FishNote/themes/customTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fish_catch_provider.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => FishCatchProvider(),
      child: MaterialApp(
        title: 'FishNote',
        theme: CustomTheme.getThemeData(context),
        home: const HomeScreen(),
      ),
    );
  }
}

