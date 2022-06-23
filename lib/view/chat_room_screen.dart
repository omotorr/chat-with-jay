import 'package:chat_with_jay/helpers/authenticate.dart';
import 'package:chat_with_jay/helpers/helperfunctions.dart';
import 'package:chat_with_jay/services/auth.dart';
import 'package:chat_with_jay/services/database.dart';
import 'package:chat_with_jay/view/conversation_screen.dart';
import 'package:chat_with_jay/view/search.dart';
import 'package:chat_with_jay/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_with_jay/helpers/constants.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key key}) : super(key: key);
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index){
              return ChatRoomTile(
                userName: snapshot.data.docs[index]["chatRoomId"]
                .toString().replaceAll("_", "")
                    .replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.docs[index]["chatRoomId"],
              );
              }) : Container();
        },);
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState((){
        chatRoomStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        actions:  [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));
            },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              child:  const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton:  FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>   SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
   ChatRoomTile({Key key, this.userName, this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text(userName.substring(0,1).toUpperCase()),
            ),
            const SizedBox(width: 8,),
            Text(userName,style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
