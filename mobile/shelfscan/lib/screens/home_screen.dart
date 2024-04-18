// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors

import 'package:ShelfScan/models/location.dart';
import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:ShelfScan/widgets/location_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoaded = false;

  List<Location> _locations = [];
  
  @override
  void initState() {
    super.initState();
    
    getData();
  }

  getData() async {
    var fetchedLocations = await RemoteServices().getLocations();
    
    if (fetchedLocations != null) {
      setState(() {
        _locations = fetchedLocations;
        _isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        // TOP BAR
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Магазины'),
        ),

        body: _isLoaded
            ? ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (contex, index) => 
                  LocationCard(
                    locationModel: _locations[index]
                  ),
              )

            : Center(
                child: CircularProgressIndicator(
                  valueColor:AlwaysStoppedAnimation<Color>(AppColor.greenDARK),
                ),
              ),
              
      )
    );
  }
}