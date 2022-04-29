import 'package:flutter/material.dart';
import 'package:medicine_reminder/Models/medicine_model.dart';
import 'package:medicine_reminder/Providers/addNewMedicineProvider.dart';
import 'package:medicine_reminder/Providers/user_data.dart';
import 'package:medicine_reminder/Screens/Home/homeScreen.dart';
import 'package:medicine_reminder/Services/userServices.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../Providers/modal_hud.dart';
import '../../../Util/constant.dart';
import '../../../Widgets/panelTitle.dart';


class AddMedicineTap extends StatefulWidget {
  @override
  State<AddMedicineTap> createState() => _AddMedicineTapState();
}

class _AddMedicineTapState extends State<AddMedicineTap> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController=TextEditingController();

  int _selectedIndex = 0;

  final List<String> _icons = [
    'drug.png',
    'inhaler.png',
    'pill_rounded.png',
    'pill.png',
    'syringe.png',
    'ointment.png'
  ];

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final ios = IOSInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: ios);

    flutterLocalNotificationsPlugin!.initialize(
        settings,
        onSelectNotification: (payload) async {});

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),
                const Center(child: Text('Add New Medicine' , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold , color: Colors.black),)),
                PanelTitle(
                  title: "Medicine Name",
                  isRequired: true,
                ),
                TextFormField(
                  maxLength: 12,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textCapitalization: TextCapitalization.words,
                  controller: nameController,
                  validator: (value){
                    if(value!.isEmpty)
                    {
                      return 'Please Enter Medicine Name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
                PanelTitle(
                  title: "Medicine Type",
                  isRequired: true,
                ),
                _buildShapesList(),
                PanelTitle(
                  title: "Medicine Interval",
                  isRequired: true,
                ),
                selectInterval(),
                PanelTitle(
                  title: "Starting Time",
                  isRequired: true,
                ),
                SelectTime(),
                const SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      final instance = Provider.of<ModalHud>(context, listen: false);
                      final providerInstance=Provider.of<AddNewMedicineProvider>(context , listen: false);
                      instance.changeIsLoading(true);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if(providerInstance.interval != null && providerInstance.timeOfDay != null && providerInstance.interval !=0)
                          {
                            try
                            {
                              List<int> intIDs = makeIDs(24 / providerInstance.interval!);
                              List<String> notificationIDs = intIDs.map((i) => i.toString()).toList();
                              Medicine myMedicine=Medicine(
                                  notificationIDs: notificationIDs,
                                  medicineName: nameController.text,
                                  medicineType: _icons[_selectedIndex],
                                  startTime: providerInstance.timeOfDay!,
                                  interval: providerInstance.interval!,
                                  userId: Provider.of<UserData>(context,listen: false).user!.id
                              );
                              UserServices.addNewMedicine(medicine: myMedicine).then((value) {
                                scheduleNotification(myMedicine);
                                print('succ');
                                Navigator.pushReplacementNamed(context,HomeScreen.id);
                                instance.changeIsLoading(false);
                              });
                            }
                            catch (e) {
                              instance.changeIsLoading(false);
                              print('error :${e.toString()}');
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
                            }
                          }
                        else
                          {
                            instance.changeIsLoading(false);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Make Sure you Select all the data required')));
                          }
                      }
                      else
                      {
                        instance.changeIsLoading(false);
                      }

                      // _submit(widget.manager);
                    },
                    color: fColor,
                    textColor: Colors.white,
                    highlightColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'Add Medicine',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      channelDescription: 'repeatDailyAtTime description',
      importance: Importance.max,
      priority: Priority.max,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin!.showDailyAtTime(
          int.parse(medicine.notificationIDs[i]),
          'Mediminder: ${medicine.medicineName}',
          'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
  }

  Widget _buildShapesList() {
    return Container(
      width: double.infinity,
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _icons
            .asMap()
            .entries
            .map((MapEntry map) => _buildIcons(map.key))
            .toList(),
      ),
    );
  }

  Widget _buildIcons(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: (index == _selectedIndex)
              ? Theme.of(context).accentColor.withOpacity(.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Image.asset('assets/images/' + _icons[index]),
      ),
    );
  }
}
class selectInterval extends StatefulWidget {

  @override
  _selectIntervalState createState() => _selectIntervalState();
}

class _selectIntervalState extends State<selectInterval> {
  final _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Remind me every  ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: const Color(0xFF3EB16F),
              hint: _selected == 0
                  ? const Text(
                "Select an Interval",
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal!;
                  Provider.of<AddNewMedicineProvider>(context,listen: false).setInterval(_selected);
                });
              },
            ),
            Text(
              _selected == 1 ? " hour" : " hours",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
   // final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        Provider.of<AddNewMedicineProvider>(context,listen: false).setTime("${convertTime(_time.hour.toString())}" + "${convertTime(_time.minute.toString())}");
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: FlatButton(
          color: const Color(0xFF3EB16F),
          shape: const StadiumBorder(),
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Pick Time"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}