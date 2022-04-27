import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/user_data.dart';
import '../../../Widgets/medicine_card.dart';

class HomeTap extends StatefulWidget {

  @override
  State<HomeTap> createState() => _HomeTapState();
}

class _HomeTapState extends State<HomeTap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getMedicine();
    });
  }
  getMedicine()
  {
    Provider.of<UserData>(context,listen: false).getMyMedicine();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Medicine List'),
            Divider(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 5 ,
                ),
                itemCount: Provider.of<UserData>(context).medicines.length,
                itemBuilder: (context, index) {
                  return MedicineCard(medicine: Provider.of<UserData>(context).medicines[index] , index : index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
