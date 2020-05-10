import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/modules/user_auth.dart';

Message message = Message();

class Message {
  Firestore _fireStore = Firestore.instance;

  sendMessage(String message) {
    _fireStore.collection("messages").add({
      'text': message,
      'sender': userAuth.loggedUser.email,
    });
  }
}
