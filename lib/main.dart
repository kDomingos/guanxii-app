import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guanxii_app/HomePage.dart';
import 'package:guanxii_app/constants.dart';
import 'package:guanxii_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guanxii',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool loginStatus = snapshot.data!.getBool(isLoginKey) ?? false;
              if (loginStatus) {
                usermail = snapshot.data!.getString(userMailKey) ?? '';
                userName = snapshot.data!.getString(userNamekey) ?? '';
                avatarimage = snapshot.data!.getString(avatarimageurlkey) ?? '';
                print(avatarimage);
              }
              return loginStatus ? MyHomePage(avatarimage) : LoginPage();
            } else {
              return const Center(
                  child:
                      SizedBox(height: 50, child: CircularProgressIndicator()));
            }
          }),
    );
  }
}
