import 'package:chat_with_jay/helpers/authenticate.dart';
import 'package:chat_with_jay/view/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helpers/helperfunctions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;               /// if there is a value i.e false, authenticate screen will be visible always
  @override
  initState(){
    getLoggedInState();
    super.initState();
  }
  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) => setState((){
      userIsLoggedIn = value;
    }));
  }
  /// whenever the app starts, check through shared pref if user is logged in already or not....
  /// if he is already logged in then show him chat room.
  /// if he is not,show him the authentication screen
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff145C9E),
        scaffoldBackgroundColor: const Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:   userIsLoggedIn ? const ChatRoom(): const Authenticate()   /// if it true, userloggedin will be tested and chatroom will be shown,else authenticate will be shown

    );
  }
}


