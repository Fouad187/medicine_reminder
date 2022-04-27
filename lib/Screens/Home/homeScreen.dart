import 'package:flutter/material.dart';

import '../../Util/constant.dart';
import 'Taps/addMedicineTap.dart';
import 'Taps/homeTap.dart';

class HomeScreen extends StatefulWidget {
  static String id='HomeScreenId';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex=0;
  final taps=[
    HomeTap(),
    AddMedicineTap(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: fColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: fColor,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Add Medicine',
          ),
        ],
      ),
      body: taps[currentIndex],
    );
  }
}
