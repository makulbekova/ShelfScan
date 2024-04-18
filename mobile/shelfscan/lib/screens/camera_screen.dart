// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ShelfScan/main.dart';
import 'package:ShelfScan/screens/scan_screen.dart';
import 'package:ShelfScan/services/remote_services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final int locationId;
  const CameraScreen({
    Key? key, 
    required this.locationId
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  final RemoteServices _remoteServices = RemoteServices();
  String _base64String = '';

  @override
  void initState() {
    super.initState();
    
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  ImagetoBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
 
    setState(() {
      _base64String = base64.encode(bytes);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TOP BAR
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            color: Colors.black,
            Icons.arrow_back_ios_new, 
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      // CAMERA
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child:  CameraPreview(_cameraController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.circle),
              iconSize: 72,
              onPressed: () async {
                if (!_cameraController.value.isInitialized) {
                  return;
                }
                if (_cameraController.value.isTakingPicture) {
                  return;
                }

                setState(() {});

                try {
                  await _cameraController.setFlashMode(FlashMode.auto);
                  XFile imageFile = await _cameraController.takePicture();
                  File file       = File(imageFile.path);

                  await ImagetoBase64(file);
                  int? scanId = await _remoteServices.uploadAndProcessRealogramPhoto(widget.locationId, _base64String);
                  
                  if (scanId != null){
                    // close camera
                    Navigator.of(context).pop();

                    // open Scan Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(scanId: scanId),
                      ),
                    );
                  }

                } on CameraException catch (e) {
                  debugPrint('Something went wrong! $e');
                  return;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
