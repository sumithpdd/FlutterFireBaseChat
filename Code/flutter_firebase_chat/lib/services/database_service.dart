import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat/models/user_model.dart';
import 'package:flutter_firebase_chat/utils/constants.dart';

class DataBaseService {
  Future<User> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.document(userId).get();
    return User.fromDoc(userDoc);
  }

  Future<List<User>> searchUsers(String currentUserId, String name) async {
    QuerySnapshot userSnapshot = await usersRef
        .where('name', isGreaterThanOrEqualTo: name)
        .getDocuments();
    List<User> users = [];
    userSnapshot.documents.forEach((doc) {
      User user = User.fromDoc(doc);
      if (user.id != currentUserId) users.add(user);
    });
    return users;
  }
}
