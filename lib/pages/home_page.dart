import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signOut() {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
        ],
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Warna background biru
        ),
        child: _buildUserList(),
      ),
    );
  }

  //show all user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>(
                  (doc) => _buildUserListItem(doc),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    if (_firebaseAuth.currentUser!.email != data["email"]) {
      return Column(
        children: [
          ListTile(
            title: Text(
              data["email"],
              style: TextStyle(
                color: Colors.white, // Warna teks email
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserID: data["uid"],
                    receiverUserEmail: data["email"],
                  ),
                ),
              );
            },
          ),
          Container(
            height: 1,
            color: Colors.white, // Warna garis
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
