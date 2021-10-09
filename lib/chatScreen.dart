import 'package:chat_app/fireBAseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();

  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  TextEditingController msg = TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                service.signOut(context);

                // remove email this preference
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(loginUser!.email.toString()),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: ShowMessages()),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.2)
                      )
                    ),
                    child: TextField(
                      controller: msg,
                      decoration: InputDecoration(hintText: "Enter Message..."),
                    ),
                  ),
                ),
                IconButton(onPressed: () {
                  if(msg.text.isNotEmpty) {
                    storeMessage.collection("Messages").doc().set({
                      "messages": msg.text.trim(  ),
                      "user": loginUser!.email.toString(),
                      "time": DateTime.now()
                    });
                    msg.clear();
                  }
                }, icon: Icon(Icons.send))
              ],
            ),
      
          ],
        ),
      ),
    );
  }
}

class ShowMessages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Messages").orderBy("time").snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          primary: true,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, i) {
            QueryDocumentSnapshot x = snapshot.data!.docs[i];
            return ListTile(
              title: Column(
                crossAxisAlignment: loginUser!.email == x['user'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: loginUser!.email == x['user'] ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          x['messages']
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          x['user'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  ),
                ],
              )
            );
          },
        );
      },
    );
  }
}
