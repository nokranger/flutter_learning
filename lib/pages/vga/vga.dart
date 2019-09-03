import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';

import 'package:pc_build/pages/vga/vga-detail.dart';
import 'package:pc_build/models/vga.dart';

class VgaPage extends StatefulWidget {
  @override
  _VgaPageState createState() => _VgaPageState();
}

class _VgaPageState extends State<VgaPage> {
  List<Vga> vgas = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    var url = 'https://www.advice.co.th/pc/get_comp/vga';
    final store = await CacheStore.getInstance();
    File file = await store.getFile(url);
    final jsonString = json.decode(file.readAsStringSync());
    setState(() {
      jsonString.forEach((v) {
        final vga = Vga.fromJson(v);
        if(vga.advId != '') vgas.add(vga);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PC Build'),
      ),
      body: ListView.builder(
        itemCount: vgas.length,
        itemBuilder: (context, i) {
          return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VgaDetailPage(),
                  )),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: CachedNetworkImage(
                      imageUrl: "https://www.advice.co.th/pic-pc/vga/${vgas[i].vgaPicture}",
                      // placeholder: (context, url) =>
                      //     CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text('${vgas[i].vgaModel}'),
                      Text('${vgas[i].vgaBrand}'),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}
