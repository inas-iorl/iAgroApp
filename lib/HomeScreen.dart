import 'package:co2_app_server/screens/Fields.dart';
import 'package:co2_app_server/screens/Map.dart';
import 'package:co2_app_server/screens/MyDevices.dart';
import 'package:co2_app_server/screens/FieldInfo.dart';
import 'package:co2_app_server/screens/Recommend.dart';
import 'package:co2_app_server/screens/Shop.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'models/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    MapScreen(),
    // FieldsScreen(),
    // RecommendTab(),
    DevicesScreen(),
    ShopScreen(),
    // MyFieldTabScreen(),
    // RecommendTab(),
    // ShopTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.red,
            label: "Мои поля",
            activeIcon: Column(
              children: <Widget>[
                Icon(Icons.home),
              ],
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.science),
              label: 'Наборы'
              // label: 'Tab 2'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'map',
            // label: 'Tab 3',
          ),
        ],
      )
    );
  }
}