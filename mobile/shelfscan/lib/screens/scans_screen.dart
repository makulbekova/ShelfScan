// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:ShelfScan/models/scan.dart';
import 'package:ShelfScan/screens/camera_screen.dart';
import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:ShelfScan/widgets/scan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScansScreen extends StatefulWidget {
  final int locationId;
  final String locationName;
  final String locationAddress;

  const ScansScreen({
    Key? key,
    required this.locationId,
    required this.locationName,
    required this.locationAddress,
  }) : super(key: key);

  @override
  State<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends State<ScansScreen> {
  List<Scan> scans = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
    
  }

  getData() async {
  var fetchedScans = await RemoteServices().getScansFromLocation(widget.locationId);
  if (fetchedScans != null && mounted) { // Add mounted check here
    setState(() {
      scans = fetchedScans;
      _isLoaded = true;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ), 
          centerTitle: true,
          title: const Text('Посещения'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                getData();
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.greenMAIN,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => CameraScreen(locationId: widget.locationId)));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.locationName.toUpperCase(),
                    style: TextStyle(
                      color: AppColor.redMAIN,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    widget.locationAddress,
                    style: TextStyle(
                      color: AppColor.redDARK,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 1, left: 1),
              child: Divider(
                color:AppColor.greyGreen,
                thickness: 1,
              ),
            ),
            Expanded(
              // Display list of scans
              child: _isLoaded
                  ? ListView.builder(
                      itemCount: scans.length,
                      itemBuilder: (context, index) => ScanCard(
                        scanModel: scans[index],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:AlwaysStoppedAnimation<Color>(AppColor.greenDARK),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
