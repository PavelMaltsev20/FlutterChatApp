import 'package:chat_app_flutter/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return StreamBuilder(
              stream: Firestore.instance
                  .collection("chat")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container());
                } else {
                  return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (ctx, index) {
                        final chatDocs = snapshot.data.documents[index];
                        return MessageBubble(
                          key: ValueKey(chatDocs.documentID),
                          message: chatDocs["text"],
                          userName: chatDocs["username"],
                          imageUrl: chatDocs["imageUrl"],
                          currentUser:
                              chatDocs["userId"] == futureSnapshot.data.uid,
                        );
                      });
                }
              },
            );
          }
        });
  }
}
