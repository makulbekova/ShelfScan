// ignore_for_file: prefer_const_constructors
import 'package:ShelfScan/services/remote_services.dart';
import 'package:ShelfScan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Box _boxLogin = Hive.box("login");
  final Box _boxAuth = Hive.box("auth");
  late String _firstName = 'Иван';
  late String _lastName = 'Иваныч';
  late String _phone = '+7 777 777 77 77';

  bool _isLoaded = true;
  List<Map<String, dynamic>>? _chartData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      _isLoaded = true;
    });

    var employeeData = await RemoteServices().getEmployeeData();
    if (employeeData != null) {
      setState(() {
        _firstName = employeeData.firstName;
        _lastName = employeeData.lastName;
        _phone = employeeData.phone;
        _isLoaded = false;
      });
    } else {
      setState(() {
        _isLoaded = false;
      });
    }

    var scanCountsData = await RemoteServices().getScanCountsForLastSevenDays();
    if (scanCountsData != null) {
      setState(() {
        _chartData = scanCountsData;
      });
    } else {
      setState(() {
        _isLoaded = false;
      });
    }
  }

  void closeAppUsingSystemPop() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  String formatPhone(String phoneNumber) {
    String numericOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (numericOnly.length >= 11) {
      String countryCode = numericOnly.substring(0, 1);
      String areaCode = numericOnly.substring(1, 4);
      String phone = numericOnly.substring(4);

      return '+$countryCode ($areaCode) ${phone.substring(0, 3)} ${phone.substring(3, 5)}-${phone.substring(5)}';
    } else {
      return phoneNumber;
    }
  }

  Widget _buildChart(List<Map<String, dynamic>>? data) {
    if (data == null || data.isEmpty) {
      return SizedBox.shrink();
    }

    final List<charts.Series<Map<String, dynamic>, String>> series = [
      charts.Series<Map<String, dynamic>, String>(
        id: 'ScanCounts',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColor.greenDARK),
        domainFn: (scan, _) {
          final date = DateTime.parse(scan['date'] as String);
          return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
        },
        measureFn: (scan, _) => scan['scan_count'] as int,
        data: data,
      ),
    ];

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: charts.BarChart(
          series,
          animate: true,
          barGroupingType: charts.BarGroupingType.grouped,
          defaultRenderer: charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(7),
          ),
          domainAxis: charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
              labelStyle: charts.TextStyleSpec(
                fontSize: 12,
              ),
            ),
          ),
          primaryMeasureAxis: charts.NumericAxisSpec(
            renderSpec: charts.GridlineRendererSpec(
              lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shadeDefault,
              ),
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Профиль'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              color: AppColor.redMAIN,
              tooltip: 'Выйти',
              onPressed: () {
                _boxLogin.put("loginStatus", false);
                _boxAuth.clear();
                closeAppUsingSystemPop();
              },
            ),
          ],
        ),
        body: _isLoaded
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 17),
                    color: AppColor.greenMAIN,
                    height: 90,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_firstName $_lastName",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatPhone(_phone),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 2),
                    child: const Text(
                      "Статистика",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(8),
                        child: _buildChart(_chartData),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
