import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashchat/modules/user_auth.dart';

MessageModule messageModule = MessageModule();

class MessageModule {
  Firestore _fireStore = Firestore.instance;

  sendMessage(String message) async {
    await _fireStore.collection("messages").add({
      'text': message,
      'sender': userAuth.loggedUser.email,
      'time': DateTime.now()
    });
  }

  getMessage() async {
    final messages = await _fireStore.collection("messages").getDocuments();
    for (var message in messages.documents) {
      print(message.data);
    }
  }

  messageStream() {
    return _fireStore.collection("messages").snapshots();
  }
}
