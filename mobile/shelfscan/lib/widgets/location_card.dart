import 'package:ShelfScan/models/location.dart';
import 'package:ShelfScan/screens/scans_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key, required this.locationModel}) : super(key: key);
  final Location locationModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (contex) => ScansScreen(
                      locationId: locationModel.id,
                      locationName: locationModel.name,
                      locationAddress: locationModel.address,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            title: Text(
              locationModel.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                const SizedBox(
                  width: 3,
                ),
                Text(
                  locationModel.address,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: locationModel.lastScanDatetime != DateTime(1, 1, 1, 0, 0, 0)
                          ? Text(DateFormat('dd.MM.yy').format(locationModel.lastScanDatetime))
                          : const Text(""),
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