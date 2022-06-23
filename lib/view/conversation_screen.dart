import 'package:chat_with_jay/helpers/constants.dart';
import 'package:chat_with_jay/services/database.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';
class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
   const ConversationScreen({Key key, this.chatRoomId}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageEditingController = TextEditingController();
  Stream chats;
  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.docs[index]["message"],
              sendByMe: snapshot.data.docs[index]["sendBy"]==Constants.myName,
                //sendByMe: Constants.myName
            );
            }): Container();
        },
    );
  }

  sendMessage(){
    if(messageEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,

      };
      databaseMethods.addChats(widget.chatRoomId, messageMap);
      //setState((){
        messageEditingController.text="";
     // });
    }
  }
    @override
  void initState(){
    databaseMethods.getChats(widget.chatRoomId).then((value){
      setState((){
        chats = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                    color: const Color(0x54FFFFFF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16),
                    child:Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: messageEditingController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: "Message...",
                                  hintStyle: TextStyle(
                                      color: Colors.white54
                                  ),
                                  border: InputBorder.none
                              )
                          ),
                        ),
                        GestureDetector(
                           onTap: sendMessage,
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
                              child: Image.asset("assets/images/send.png"),))
                      ],
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  const MessageTile({Key key, this.message, this.sendByMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            const BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
