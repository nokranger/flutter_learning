import 'package:flutter/material.dart';

import 'package:pc_build/pages/vga/vga.dart'; //import mypage
import 'package:pc_build/pages/cpu/cpu.dart';


void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CpuPage(),
    );
  }
}