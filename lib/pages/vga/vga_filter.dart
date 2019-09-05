import 'package:flutter/material.dart';
import 'package:pc_build/models/vga.dart';

class VgaFilterPage extends StatefulWidget {
  final VgaFilter vgaFilter;

  VgaFilterPage({Key key,this.vgaFilter}):super(key:key);
  @override
  _VgaFilterPageState createState() => _VgaFilterPageState();
}

class _VgaFilterPageState extends State<VgaFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Back'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
