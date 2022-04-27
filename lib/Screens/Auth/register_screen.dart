import 'package:flutter/material.dart';
import 'package:medicine_reminder/Screens/Home/homeScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../Providers/modal_hud.dart';
import '../../Services/auth_services.dart';
import '../../Util/constant.dart';
import '../../Widgets/auth_button.dart';
import '../../Widgets/text_field.dart';

class RegistrationScreen extends StatelessWidget {
  static String id='RegistrationScreenID';

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Auth auth=Auth();

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmController=TextEditingController();

 // Auth auth=Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account' , style: TextStyle(color: Colors.black),),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModalHud>(context).isChange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Let\'s Get Started' , style: TextStyle(fontWeight: FontWeight.w600 , fontSize: 25),),
                  const SizedBox(height: 5,),
                  const Text('Sign up to start your trip and get full access' , style: TextStyle(color: Colors.grey , fontSize: 18),),
                  const SizedBox(height: 50,),
                  MyTextField(label: 'Name', picon: const Icon(Icons.person , color: fColor,), controller: nameController ,
                    validate: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please enter your name';
                      }
                    },),
                  const SizedBox(height: 20,),
                  MyTextField(label: 'Email', picon: const Icon(Icons.email, color: fColor), controller: emailController,
                    validate: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please enter your email';
                      }
                    },),
                  const SizedBox(height: 20,),
                  MyTextField(label: 'Password', picon: const Icon(Icons.lock, color: fColor), security: true ,controller: passwordController ,
                    validate: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please enter your password';
                      }
                    },),
                  const SizedBox(height: 20,),
                  MyTextField(label: 'Confirm Password', picon: const Icon(Icons.lock, color: fColor),security: true, controller: confirmController,
                    validate: (String value){
                      if(value.isEmpty)
                      {
                        return 'Please enter your confirm password';
                      }
                    },),
                  const SizedBox(height: 30,),
                  Center(child: AuthButton(
                      tap: () async {
                        final instance = Provider.of<ModalHud>(context, listen: false);
                        instance.changeIsLoading(true);
                        if (_globalKey.currentState!.validate())
                        {
                          try {
                            await auth.createAccount(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            ).then((value) {
                              instance.changeIsLoading(false);
                              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id , (route)=> false);
                            });


                          }
                          catch (e) {
                            print(e.toString());
                            instance.changeIsLoading(false);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email Must be Unique'),));
                          }
                        }
                      },
                      text: 'Create')),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      const SizedBox(width: 5,),
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Text('Login here' , style: TextStyle(fontWeight: FontWeight.w500 , color: fColor),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
