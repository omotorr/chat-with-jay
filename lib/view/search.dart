

import 'package:chat_with_jay/helpers/constants.dart';
import 'package:chat_with_jay/services/database.dart';
import 'package:chat_with_jay/view/conversation_screen.dart';
import 'package:chat_with_jay/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchTextEditingController =  TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList(){
    print(searchSnapshot);
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,//use when you are using a listview inside a column
        itemBuilder: (context, index){
          return  SearchTile(
            userName: searchSnapshot.docs[index]["name"],
            userEmail: searchSnapshot.docs[index]["email"],
          );
        }) : Container();
  }

  initiateSearch(){
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
          setState((){
            searchSnapshot = val;
          });
    });
  }
  /// 1.create a chatroom, send user to the chatroom, push replacement
  sendMessage({String userName}){
    print("${Constants.myName}");
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users =[userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatRoomId" : chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context)=>  ConversationScreen(chatRoomId: chatRoomId,)
      ));
    }else {
      print("You cannot send messages to yourself");
    }
   
  }
  
  
  Widget SearchTile({String userName, String userEmail}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: mediumTextStyle(),),
              Text(userEmail,style: mediumTextStyle(),),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(
                userName: userName,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
              child: Text("Message",
                style: mediumTextStyle(),),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState(){
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16),
                child:Row(
                  children: [
                     Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search username...",
                          hintStyle: TextStyle(
                              color: Colors.white54
                          ),
                          border: InputBorder.none
                        )
                      ),
                    ),
                GestureDetector(
                  onTap: initiateSearch,
                child:Container(
                  height: 40,
                  width: 40,
                  decoration:  BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0x36FFFFFF),
                        Color(0x0FFFFFFF)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  padding: EdgeInsets.all(10),
                  child: Image.asset("assets/images/search_white.png"),))
              ],
            )),
            searchList(),
          ],
        ),
      ),
    );
  }
}


