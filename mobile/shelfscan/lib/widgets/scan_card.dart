import 'package:ShelfScan/models/scan.dart';
import 'package:ShelfScan/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScanCard extends StatelessWidget {
  ScanCard({Key? key, required this.scanModel}) : super(key: key);
  final Scan scanModel;

  String getLabel(int count) {
    if (count == 1) {
      return 'ценник';
    } else if (count >= 2 && count <= 4) {
      return 'ценника';
    } else {
      return 'ценников';
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanScreen(
              scanId: scanModel.scanId
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${scanModel.productsCount.toString()} ${getLabel(scanModel.productsCount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('dd.MM.yy').format(scanModel.scanDatetime),
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Divider(
              thickness: .8,
            ),
          ),
        ],
      ),
    );
  }
}
