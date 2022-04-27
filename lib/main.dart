import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/addNewMedicineProvider.dart';
import 'Providers/modal_hud.dart';
import 'Providers/user_data.dart';
import 'Screens/Auth/login_screen.dart';
import 'Screens/Auth/register_screen.dart';
import 'Screens/Home/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModalHud>(create: (context) => ModalHud(),),
        ChangeNotifierProvider<UserData>(create: (context) => UserData(),),
        ChangeNotifierProvider<AddNewMedicineProvider>(create: (context) => AddNewMedicineProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoginScreen.id,
        routes: {
          /// Auth
          LoginScreen.id : (context)=> LoginScreen(),
          RegistrationScreen.id : (context)=> RegistrationScreen(),

          HomeScreen.id : (context)=> HomeScreen(),
        },
      ),
    );
  }
}
