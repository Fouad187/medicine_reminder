import 'package:flutter/material.dart';

import '../../Services/auth_services.dart';
import '../../Util/constant.dart';
import '../Auth/login_screen.dart';
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
        actions: [
          InkWell(
            onTap: (){
              Auth auth=Auth();
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
            },
            child: const Padding(
              padding:  EdgeInsets.all(10),
              child: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
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
