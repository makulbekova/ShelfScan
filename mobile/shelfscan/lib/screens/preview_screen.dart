// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  PreviewScreen({super.key, required this.file});
  XFile file;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ), 
        title: const Text('Просмотр'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Image.file(picture),

              const SizedBox(height: 10),

              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        '''Точка:  SMALL
Адрес: г.Астана, Кабанбай Батыра 49А
Дата:    28.03.2024, 9:41''',
                      ),
                    ),
                  ),
                ],
              ),
            ]
          )
        )
      ),
    );
  }
}