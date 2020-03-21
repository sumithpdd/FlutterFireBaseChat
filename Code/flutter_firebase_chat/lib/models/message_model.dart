import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id, senderId, text, imageUrl;
  final Timestamp timestamp;

  Message({
    this.id,
    this.senderId,
    this.text,
    this.imageUrl,
    this.timestamp,
  });

  factory Message.fromDoc(DocumentSnapshot doc) {
    return Message(
        id: doc.documentID,
        senderId: doc['senderId'],
        text: doc['text'],
        imageUrl: doc['imageUrl'],
        timestamp: doc['timestamp']);
  }
}
