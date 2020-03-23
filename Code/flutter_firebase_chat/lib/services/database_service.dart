import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_chat/models/chat_model.dart';
import 'package:flutter_firebase_chat/models/message_model.dart';
import 'package:flutter_firebase_chat/models/user_data.dart';
import 'package:flutter_firebase_chat/models/user_model.dart';
import 'package:flutter_firebase_chat/services/storage_service.dart';
import 'package:flutter_firebase_chat/utils/constants.dart';
import 'package:provider/provider.dart';

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

  Future<bool> createChat(
    BuildContext context,
    String name,
    File file,
    List<String> users,
  ) async {
    String imageUrl = await Provider.of<StorageService>(context, listen: false)
        .uploadChatImage(null, file);

    List<String> memberIds = [];
    Map<String, dynamic> memberinfo = {};
    Map<String, dynamic> readStatus = {};
    for (String userId in users) {
      User user = await getUser(userId);
      memberIds.add(userId);
      Map<String, dynamic> userMap = {
        'name': user.name,
        'email': user.email,
        'token': user.token,
      };
      memberinfo[userId] = userMap;
      readStatus[userId] = false;
      await chatsRef.add({
        'name': name,
        'imageUrl': imageUrl,
        'recentMessage': 'Chat created',
        'recentSender': '',
        'recentTimestamp': Timestamp.now(),
        'memberIds': memberIds,
        'memberInfo': memberinfo,
        'readStatus': readStatus,
      });
    }
    return true;
  }

  void sendChatMessage(Chat chat, Message message) {
    chatsRef.document(chat.id).collection('messages').add({
      'senderId': message.senderId,
      'text': message.text,
      'imageUrl': message.imageUrl,
      'timestamp': message.timestamp,
    });
  }

  void setChatRead(BuildContext context, Chat chat, bool read) async {
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    chatsRef.document(chat.id).updateData({
      'readStatus.$currentUserId': read,
    });
  }
}
