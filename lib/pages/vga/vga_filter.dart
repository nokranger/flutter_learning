import 'package:flutter/material.dart';
import 'package:pc_build/models/vga.dart';

class VgaFilterPage extends StatefulWidget {
  final List<Vga> allVgas;
  final VgaFilter selectedFilter;

  VgaFilterPage({Key key, this.selectedFilter, this.allVgas}) : super(key: key);

  @override
  _VgaFilterPageState createState() => _VgaFilterPageState();
}

class _VgaFilterPageState extends State<VgaFilterPage> {
  VgaFilter allFilter;
  VgaFilter validFilter;
  VgaFilter selectedFilter;

  @override
  void initState() {
    super.initState();
    // allFilter = widget.allVgas;
    // selectedFilter = widget.selectedFilter;
    initData();
  }

  initData() {
    allFilter = VgaFilter.fromVgas(widget.allVgas);
    validFilter = allFilter;
    selectedFilter = widget.selectedFilter;
    recalFilter();
  }

  resetData() {
    setState(() {
      allFilter = VgaFilter.fromVgas(widget.allVgas);
      validFilter = allFilter;
      selectedFilter = VgaFilter();
    });
  }

  recalFilter() {
    setState(() {
      validFilter = VgaFilter.clone(allFilter);
      var tmpFilter = VgaFilter.clone(allFilter);

      //caclulate valid chipset
      tmpFilter.vgaBrand =
          allFilter.vgaBrand.intersection(selectedFilter.vgaBrand);
      var tmpVgas = tmpFilter.filters(widget.allVgas);
      var resultFilter = VgaFilter.fromVgas(tmpVgas);
      validFilter.vgaChipset = resultFilter.vgaChipset;
      selectedFilter.vgaChipset =
          selectedFilter.vgaChipset.intersection(validFilter.vgaChipset);

      //caclulate valid series
      tmpFilter.vgaChipset =
          allFilter.vgaChipset.intersection(selectedFilter.vgaChipset);
      tmpVgas = tmpFilter.filters(widget.allVgas);
      resultFilter = VgaFilter.fromVgas(tmpVgas);
      validFilter.vgaSeries = resultFilter.vgaSeries;
      selectedFilter.vgaSeries =
          selectedFilter.vgaSeries.intersection(validFilter.vgaSeries);
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> allBrandList = allFilter.vgaBrand.toList()..sort();
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            tooltip: 'Reset',
            onPressed: () => resetData(),
          ),
          IconButton(
            icon: Icon(Icons.check),
            tooltip: 'OK',
            onPressed: () {
              Navigator.pop(context, selectedFilter);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Brands'),
            trailing: clearAllMaker(selectedFilter.vgaBrand),
          ),
          filterChipMaker(allFilter.vgaBrand, validFilter.vgaBrand,
              selectedFilter.vgaBrand),
          ListTile(
            title: Text('Chipset'),
            trailing: clearAllMaker(selectedFilter.vgaChipset),
          ),
          filterChipMaker(allFilter.vgaChipset, validFilter.vgaChipset,
              selectedFilter.vgaChipset),
          ListTile(
            title: Text('Series'),
            trailing: clearAllMaker(selectedFilter.vgaSeries),
          ),
          filterChipMaker(allFilter.vgaSeries, validFilter.vgaSeries,
              selectedFilter.vgaSeries),
        ],
      ),
    );
  }

  Widget clearAllMaker(Set<String> selected) {
    return FlatButton(
      child: Text('clear all'),
      onPressed: selected.length == 0
          ? null
          : () {
              setState(() {
                selected.clear();
                recalFilter();
              });
            },
    );
  }

  Widget filterChipMaker(Set<String> all, Set<String> valid, Set<String> s) {
    List<String> allList = all.toList()..sort();
    return Wrap(
      children: allList.map((b) {
        return Container(
          margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: FilterChip(
            avatar: Text(' '),
            label: Text(b),
            selected: s.contains(b),
            // disabledColor: Colors.black,
            onSelected: !valid.contains(b)
                ? null
                : (bool sel) {
                    setState(() {
                      if (sel) {
                        s.add(b);
                        recalFilter();
                      } else {
                        s.remove(b);
                        recalFilter();
                      }
                    });
                  },
          ),
        );
      }).toList(),
    );
  }
}
