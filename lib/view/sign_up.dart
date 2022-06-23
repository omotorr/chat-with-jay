import 'package:chat_with_jay/helpers/helperfunctions.dart';
import 'package:chat_with_jay/services/auth.dart';
import 'package:chat_with_jay/services/database.dart';
import 'package:chat_with_jay/view/chat_room_screen.dart';
import 'package:chat_with_jay/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key, this.toggle}) : super(key: key);
  final Function toggle;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  HelperFunctions helperFunctions =HelperFunctions();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =  TextEditingController();
  TextEditingController emailTextEditingController =  TextEditingController();
  TextEditingController passwordTextEditingController =  TextEditingController();

  singUp() async{
    if(formKey.currentState.validate()){

      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text,);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text,);

      setState((){
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
        //print("${val.uid}");


        databaseMethods.uploadUserInfo(userInfoMap); ///  upload the date
        HelperFunctions.saveUserLoggedInSharedPreference(true);  ///  save log info to local storage
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: const Center(child: CircularProgressIndicator())
      ): SingleChildScrollView(
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
                          return val.isEmpty || val.length < 4 ? "Please provide valid username": null;
                        },
                          controller: userNameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Username")
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Please enter valid email";
                        },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("Email")
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 6 ? null : "Please enter 6+ password character";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Password"),
                      ),
                    ],
                  ),
                  ),
                  const SizedBox(height: 8,),
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
                      singUp();
                    },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration:  BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xff007EF4), Color(0xff2A75BC)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up",
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
                    child: const Text("Sign up with Google",
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
                      Text("Already have an account?",style: mediumTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: const Text("Sign in ",style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),),),
                      )
                    ],
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
