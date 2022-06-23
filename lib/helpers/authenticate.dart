import 'package:chat_with_jay/view/sign_up.dart';
import 'package:flutter/material.dart';

import '../view/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView(){
    setState((){
      showSignIn =! showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
     if(showSignIn){
      return  SignIn(toggle: toggleView);
    }else{
      return  SignUp(toggle: toggleView);
    }
  }
}
