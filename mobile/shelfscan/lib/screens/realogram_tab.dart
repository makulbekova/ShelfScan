import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ShelfScan/models/scan_info.dart';
import 'package:ShelfScan/services/remote_services.dart';

class RealogramTab extends StatefulWidget {
  final int scanId;

  const RealogramTab({
    Key? key,
    required this.scanId,
  }) : super(key: key);

  @override
  State<RealogramTab> createState() => _RealogramTabState();
}

class _RealogramTabState extends State<RealogramTab> {
  bool _isLoaded = true;
  late ScanInfo scanInfo;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoaded = true;
    });

    try {
      var fetchedScanInfo = await RemoteServices().getScanInfo(widget.scanId);
      if (fetchedScanInfo != null) {
        setState(() {
          scanInfo = fetchedScanInfo;
          _isLoaded = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoaded = false;
      });
      // Handle error if necessary
      print('Error: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _isLoaded
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            physics: ClampingScrollPhysics(), // Disable scrolling
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0, // Maintain aspect ratio of the image
                  child: Image.memory(
                    base64Decode(scanInfo.photoBase64),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Точка: ${scanInfo.name}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Адрес: ${scanInfo.fullAddress}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Дата: ${DateFormat('dd.MM.yy').format(scanInfo.scanDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                // Add more Text widgets to display other attributes if needed
              ],
            ),
          ),
  );
}

}
