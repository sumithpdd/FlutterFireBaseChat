import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/screens/home_screen.dart';
import 'package:flutter_firebase_chat/screens/login_screen.dart';
import 'package:flutter_firebase_chat/services/auth_service.dart';
import 'package:flutter_firebase_chat/services/database_service.dart';
import 'package:provider/provider.dart';

import 'models/user_data.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => UserData(),
      ),
      Provider<AuthService>(
        create: (_) => AuthService(),
      ),
      Provider<DataBaseService>(
        create: (_) => DataBaseService(),
      )
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: StreamBuilder<FirebaseUser>(
        stream: Provider.of<AuthService>(context, listen: false).user,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context, listen: false).currentUserId =
                snapshot.data.uid;
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
