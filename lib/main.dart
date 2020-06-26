import 'package:flutter/material.dart';
import 'package:newww/root_page.dart';

import 'authentication.dart';
import 'login_signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primaryColor: Color(0xff145C9E),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RootPage(auth: Auth()),
    );
  }
}

