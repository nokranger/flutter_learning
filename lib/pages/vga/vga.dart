import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';

import 'package:pc_build/pages/vga/vga_detail.dart';
import 'package:pc_build/models/vga.dart';
import 'package:pc_build/pages/vga/vga_filter.dart';

class VgaPage extends StatefulWidget {
  @override
  _VgaPageState createState() => _VgaPageState();
}

class _VgaPageState extends State<VgaPage> {
  List<Vga> vgas = [];

  String sortBy = 'latest'; //lates  low2high high2low
  BuildContext _scaffoldContext; //snackbar
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  VgaFilter vgaFilter = VgaFilter();
  String sortsby = 'Latest';
  final List<String> _dropdownValues = [
    'Latest',
    'Low to high',
    'High to low',
  ];
  String _currentlySelected = '';
  final List<String> _iconss = ['settings', 'settings', 'settings'];
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
        if (vga.advId != '' && vga.vgaPriceAdv != 0) vgas.add(vga);
      });
    });
  }

  sortAction() {
    setState(() {
      if (sortBy == 'latest') {
        sortBy = 'low2high';
        vgas.sort((a, b) {
          return a.vgaPriceAdv - b.vgaPriceAdv;
        });
      } else if (sortBy == 'low2high') {
        sortBy = 'high2low';
        vgas.sort((a, b) {
          return b.vgaPriceAdv - a.vgaPriceAdv;
        });
      } else {
        sortBy = 'latest';
        vgas.sort((a, b) {
          return b.id - a.id;
        });
      }
    });
  }

  showMessage(String txt) {
    // Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
    //   content: Text(txt),
    //   duration: Duration(seconds: 1),
    // ));
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(txt),
      duration: Duration(seconds: 1),
    ));
  }

  Widget dropdownWidget() {
    return DropdownButton(
      //map each value from the lIst to our dropdownMenuItem widget
      items: _dropdownValues
          .map((value) => DropdownMenuItem(
                child: Row(children: <Widget>[
                  Icon(Icons.sort_by_alpha),
                  Text('    ' + value),
                ]),
                value: value,
              ))
          .toList(),
      onChanged: (String value) {
        //once dropdown changes, update the state of out currentValue
        setState(() {
          _currentlySelected = value;
          if (_currentlySelected == 'Latest') {
            _currentlySelected = value;
            print(_currentlySelected);
            vgas.sort((a, b) {
              return b.id - a.id;
            });
          } else if (_currentlySelected == 'Low to high') {
            _currentlySelected = value;
            print(_currentlySelected);
            vgas.sort((a, b) {
              return a.vgaPriceAdv - b.vgaPriceAdv;
            });
          } else if (_currentlySelected == 'High to low') {
            _currentlySelected = value;
            print(_currentlySelected);
            vgas.sort((a, b) {
              return b.vgaPriceAdv - a.vgaPriceAdv;
            });
          }
        });
      },
      //this wont make dropdown expanded and fill the horizontal space
      isExpanded: false,
      //make default value of dropdown the first value of our list
      value: _dropdownValues.firstWhere((s) => s.startsWith(_currentlySelected),
          orElse: () => ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        title: Text('PC Build'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.sort),
          //   tooltip: 'Retitch it',
          //   onPressed: () {
          //     sortAction();
          //     showMessage(sortBy);
          //   },
          // )
          IconButton(
            icon: Icon(Icons.tune),
            tooltip: 'Filter',
            onPressed: () {
              // vgaFilter.vgaBrands = ['ASUS'];
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => VgaFilterPage(
              //               vgaFilter: vgaFilter,
              //             )));
              navigate2filterPage(context);
            },
          ),
          dropdownWidget(),
        ],
      ),
      body: bodyBuilder(),
    );
  }

  navigate2filterPage(BuildContext context) async{
    vgaFilter.vgaBrands = ['ASUS'];
    VgaFilter result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VgaFilterPage(
                  vgaFilter: vgaFilter,
                )));
    print('out');
    print(result.vgaBrands);
  }

  Widget bodyBuilder() {
    return ListView.builder(
      itemCount: vgas.length,
      itemBuilder: (context, i) {
        var v = vgas[i];
        return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VgaDetailPage(),
                )),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8),
                  height: 150,
                  width: 150,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://www.advice.co.th/pic-pc/vga/${v.vgaPicture}",
                    // placeholder: (context, url) =>
                    //     CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text('${v.vgaModel}'),
                    Text('${v.vgaBrand}'),
                    Text('${v.vgaPriceAdv} บาท')
                  ],
                ),
              ],
            ));
      },
    );
  }
}
