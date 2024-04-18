// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ShelfScan/screens/prices_tab.dart';
import 'package:ShelfScan/screens/realogram_tab.dart';
import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  final int scanId;

  const ScanScreen({
    Key? key,
    required this.scanId
  }) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int currentPage = 0;


  // List<Scan> scans = [];
  // bool _isLoaded = false;

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  // getData() async {
  //   var fetchedScans = await RemoteServices().getScanInfo(widget.locationId);
  //   if (fetchedScans != null) {
  //     setState(() {
  //       scans = fetchedScans;
  //       _isLoaded = true;
  //     });
  //   }
  // }
  
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [RealogramTab(scanId: widget.scanId,), PricesTab(scanId: widget.scanId,)];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          centerTitle: true,
          title: Text('Посещение'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Реалограмма'),
              Tab(text: 'Ценники'),
            ],
          ),
        ),
        body: TabBarView(
          children: tabs,
        ),
      ),
    );
  }
}