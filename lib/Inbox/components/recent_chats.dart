import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/chat_item.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/new_message_system.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class Chats extends StatefulWidget with NavigationStates {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel =
        Provider.of<UserViewModel>(context, listen: false);
    viewModel.setUser();
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/pg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: StreamBuilder(
          stream: userChatsStream('${firebaseAuth.currentUser.uid}'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List chatList = snapshot.data.documents;
              if (chatList.isNotEmpty) {
                return ListView.separated(
                  itemCount: chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot chatListSnapshot = chatList[index];
                    return StreamBuilder(
                      stream: messageListStream(chatListSnapshot.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List messages = snapshot.data.documents;
                          Message message =
                              Message.fromJson(messages.first.data());
                          List users = chatListSnapshot.data()['users'];
                          users.remove('${viewModel.user?.uid ?? ""}');
                          String recipient = users[0];
                          return ChatItem(
                            userId: recipient,
                            messageCount: messages?.length,
                            msg: message?.content,
                            time: message?.time,
                            chatId: chatListSnapshot.id,
                            type: message?.type,
                            currentUserId: viewModel.user?.uid ?? "",
                            isAgent: false,
                          );
                          return StreamBuilder(
                            stream: usersRef
                                .doc(firebaseAuth.currentUser.uid)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasData) {
                                UserModel user1 =
                                    UserModel.fromJson(snapshot.data.data());
                                if (user1.type.toLowerCase() == "agent") {
                                  return ChatItem(
                                    userId: recipient,
                                    messageCount: messages?.length,
                                    msg: message?.content,
                                    time: message?.time,
                                    chatId: chatListSnapshot.id,
                                    type: message?.type,
                                    currentUserId: viewModel.user?.uid ?? "",
                                    isAgent: true,
                                  );
                                }
                              }
                              return Container(
                                height: 0,
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Divider(),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child:
                        Text('The Chat Still Under Development See you Soon'));
              }
            } else {
              return Container(
                child: Center(
                    child:
                        Lottie.asset('assets/lotties/loading-animation.json')),
              );
            }
          }),
    ));
  }

  Stream<QuerySnapshot> userChatsStream(String uid) {
    return chatRef.where('users', arrayContains: '$uid').snapshots();
  }

  Stream<QuerySnapshot> messageListStream(String documentId) {
    return chatRef.doc(documentId).collection('messages').snapshots();
  }
}
