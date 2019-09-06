import 'package:flutter/material.dart';
import 'package:pc_build/models/vga.dart';

class VgaFilterPage extends StatefulWidget {
  final VgaFilter vgaFilter;

  VgaFilterPage({Key key, this.vgaFilter}) : super(key: key);
  @override
  _VgaFilterPageState createState() => _VgaFilterPageState();
}

class _VgaFilterPageState extends State<VgaFilterPage> {
  VgaFilter filter;
  @override
  void initState() {
    super.initState();
    // print('in');
    // print(widget.vgaFilter.selectedBrands);
    filter = widget.vgaFilter;
  }

  @override
  Widget build(BuildContext context) {
    List<String> brandList = filter.allBrands.toList()..sort();
    return Scaffold(
        appBar: AppBar(
          title: Text('Filter Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              tooltip: 'OK',
              onPressed: () {
                Navigator.pop(context, filter);
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Brands'),
              trailing: brandList.length == filter.selectedBrands.length
                  ? FlatButton(
                      child: Text('Unselect all'),
                      onPressed: () {
                        setState(() {
                          filter.selectedBrands.clear();
                        });
                      },
                    )
                  : FlatButton(
                      child: Text('Select all'),
                      onPressed: () {
                        setState(() {
                          brandList
                              .forEach((b) => filter.selectedBrands.add(b));
                        });
                      },
                    ),
            ),
            Wrap(
              children: brandList.map((b) => filterChipMaker(b)).toList(),
            )
          ],
        ));
  }

  Widget filterChipMaker(String b) {
    return Container(
      margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: FilterChip(
        avatar: Text(' '),
        label: Text(b),
        selected: filter.selectedBrands.contains(b),
        onSelected: (bool sel) {
          setState(() {
            if (sel) {
              filter.selectedBrands.add(b);
            } else {
              filter.selectedBrands.remove(b);
            }
          });
        },
      ),
    );
  }
}
