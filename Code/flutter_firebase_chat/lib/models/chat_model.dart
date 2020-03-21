import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id, name, imageUrl, recentMessage, recentSender;
  final Timestamp recentTimestamp;
  final List<dynamic> memberIds;
  final dynamic memberInfo;
  final dynamic readStatus;

  Chat(
      {this.id,
      this.name,
      this.imageUrl,
      this.recentMessage,
      this.recentSender,
      this.recentTimestamp,
      this.memberIds,
      this.memberInfo,
      this.readStatus});
      factory Chat.fromDoc(DocumentSnapshot documentSnapshot){
        return Chat(
          id:documentSnapshot.documentID,
          name:documentSnapshot['name'],
          imageUrl:documentSnapshot['imageUrl'],
          recentMessage:documentSnapshot['recentMessage'],
          recentSender:documentSnapshot['recentSender'],
          recentTimestamp:documentSnapshot['recentTimestamp'],
          memberIds:documentSnapshot['memberIds'],
          memberInfo:documentSnapshot['memberInfo'],
          readStatus:documentSnapshot['readStatus'],
        );
      }
}
