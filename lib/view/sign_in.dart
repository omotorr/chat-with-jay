import 'package:chat_with_jay/services/auth.dart';
import 'package:chat_with_jay/services/database.dart';
import 'package:chat_with_jay/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/helperfunctions.dart';
import 'chat_room_screen.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key key, this.toggle}) : super(key: key);
  final Function toggle;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn() async {
    if(formKey.currentState.validate()){                                              ///validation like sign up
      setState((){
        isLoading = true;                                                    ///show user loading option
      });
      await authMethods
          .signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text).then((val) {                    ///only if we are able to sign in then send user to next screen
        if(val != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);          ///  save log info to local storage
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const ChatRoom()
          ));
        }
      });
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text,);   /// adding email to shared preference basically saving email offline

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)     /// created functiion in db to get user by user email rather than user name
          .then((val){
        snapshotUserInfo = val;
        HelperFunctions
            .saveUserNameSharedPreference(snapshotUserInfo.docs[0]["name"]);
        print("${snapshotUserInfo.docs[0]["name"]} sign in");
      });

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Please enter valid email";
                          },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Email :")
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 6 ? null : "Please enter 6+ password character";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Password :"),
                      ),
                      SizedBox(height: 8,),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          child: Text("Forgot Password?",
                          style: simpleTextStyle(),),
                        ),
                      ),
                      const SizedBox(height: 8,),
                      GestureDetector(
                        onTap: (){
                          signIn();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration:  BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC)
                              ]
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Sign In",
                            style: mediumTextStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(38.0),
                        ),
                        child: const Text("Sign in with Google",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Text("Don't have an account?",style: mediumTextStyle(),),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: const Text("Register now",style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),),
                          ),
                          )
                        ],
                      ),
                      const SizedBox(height: 50,)
                    ],
                  ),
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
