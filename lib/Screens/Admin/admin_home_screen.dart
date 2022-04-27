import 'package:flutter/material.dart';
import 'package:medicine_reminder/Providers/admin_data.dart';
import 'package:medicine_reminder/Widgets/userWidget.dart';
import 'package:provider/provider.dart';

import '../../Services/auth_services.dart';
import '../../Util/constant.dart';
import '../Auth/login_screen.dart';
class AdminHomeScreen extends StatefulWidget {

  static String id='AdminHomeScreenId';

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getUsers();
    });
  }
  getUsers()
  {
    Provider.of<AdminData>(context,listen: false).getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder Admin' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('User List'),
            const Divider(),
            Expanded(child: RefreshIndicator(
              onRefresh: () async {
                await getUsers();
              },
              child: ListView.builder(
                itemBuilder: (context, index) =>UserWidget(user:  Provider.of<AdminData>(context).users[index], index: index),
                itemCount: Provider.of<AdminData>(context).users.length,
                physics: BouncingScrollPhysics(),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
