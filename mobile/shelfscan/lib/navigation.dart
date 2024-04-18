import 'package:ShelfScan/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:ShelfScan/screens/profile_screen.dart';
import 'package:ShelfScan/screens/home_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPage = 0;

  List<Widget> pages = const [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.greenMAIN,
        unselectedItemColor: AppColor.grey,
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.error),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}