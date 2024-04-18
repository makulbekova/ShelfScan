import 'package:flutter/material.dart';

class RemarksScreen extends StatelessWidget {
  const RemarksScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Замечания'),
        ),
        body: const Center(
          child: Text('Пока!'),
        ),
      ),
    );
  }
}