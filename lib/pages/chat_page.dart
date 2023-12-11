import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_text_from_field.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatServices.sendMessage(
          widget.receiverUserID, _messageController.text);
      //clear the controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey
              .withOpacity(0.8), // Warna biru dengan kecerahan rendah
        ),
        child: Column(
          children: [
            Expanded(
              child: _buidMessageList(),
            ),

            //user input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  //Build Message List
  Widget _buidMessageList() {
    return StreamBuilder(
      stream: chatServices.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("loading...");
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    //aligment
    var aliginment = (data["senderId"] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: aliginment,
      child: Column(
        crossAxisAlignment: (data["senderId"] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(data["senderEmail"]),
          (data["senderId"] == _firebaseAuth.currentUser!.uid)
              ? ChatBubble(
                  message: data["message"],
                  color: Colors.deepPurple,
                )
              : ChatBubble(
                  message: data['message'],
                  color: Colors.blue,
                ),
        ],
      ),
    );
  }

  //build  message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //Textform field
        Expanded(
          child: MyTextFormField(
              hintText: "Send Your Message",
              isObsecureText: false,
              controller: _messageController),
        ),

        //sending button
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            color: Colors.white, // Ubah warna ikon menjadi putih
          ),
        )
      ],
    );
  }
}
