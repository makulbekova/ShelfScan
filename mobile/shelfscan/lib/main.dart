import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'main_app.dart';

late List<CameraDescription> cameras;
void main() async {
  await _initHive();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MainApp());
}

Future<void> _initHive() async{
  await Hive.initFlutter();
  await Hive.openBox('auth');
  await Hive.openBox("login");
  await Hive.openBox("accounts");

}