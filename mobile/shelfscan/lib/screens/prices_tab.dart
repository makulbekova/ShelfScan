// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, unused_field
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ShelfScan/main.dart';
import 'package:ShelfScan/models/product.dart';
import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:ShelfScan/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PricesTab extends StatefulWidget {
  final int scanId;
  
  const PricesTab({
    Key? key,
    required this.scanId
  }) : super(key: key);

  @override
  State<PricesTab> createState() => _PricesTabState();
}

class _PricesTabState extends State<PricesTab> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final RemoteServices _remoteServices = RemoteServices();

  List<Product> products = [];
  bool _isLoaded = false;

  String base64String = '';

  @override
  void initState() {
    super.initState();
    getData();
    
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Access was desnied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
        
  }


  getData() async {
    var fetchedScans = await RemoteServices().getProductsFromScan(widget.scanId);
    if (fetchedScans != null) {
      setState(() {
        products = fetchedScans;
        _isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  ImagetoBase64(File imageFile) async {
 
    Uint8List _bytes = await imageFile.readAsBytes();
 
    String _base64String = base64.encode(_bytes);
    setState(() {
      base64String = _base64String;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              getData();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height * 0.6, 
              color: Colors.black,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CameraPreview(_cameraController),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.circle),
                      iconSize: 72,
                      onPressed: () async {
                        try {
                          await _cameraController.setFlashMode(FlashMode.auto);
                          XFile imageFile = await _cameraController.takePicture();
                          File file = File(imageFile.path);

                          await ImagetoBase64(file);
                          await _remoteServices.uploadAndProcessProductPhoto(widget.scanId, base64String);
                          await getData();
                        } on CameraException catch (e) {
                          debugPrint('Something went wrong! $e');
                          return;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            Container(
              height: size.height - (size.width), 
              child: _isLoaded
                  ? ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => ProductCard(
                        productModel: products[index],
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



