import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import './layout/HomeLayout.dart';
import './shared/bloc_observer.dart';
void main() {
  Bloc.observer=MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: HomeLayout(),
    );
  }
}

