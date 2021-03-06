import 'package:cloud_firestore/cloud_firestore.dart';


class DatabaseMethods{
  uploadUserInfo(userMap)async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userMap)
        .catchError((e){
          print(e.toString());
    });
  }
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();// to search by username... it ggoes to the collection users and gets the name key which is the username
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }
  addChats(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e){
      print(e.toString());
    });
  }
  getChats(String chatRoomId)async{
    return FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }
  getChatRooms(String userName)async{
    return  FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}