
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import 'login.dart';
import 'login_screen.dart';
class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late final FirebaseAuth  _auth = FirebaseAuth.instance;
  late User? loggedinUser;
  late String text;
  final _firestore = FirebaseFirestore.instance;
  var messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() {
    final User? user = _auth.currentUser;
    try{
      loggedinUser = user!;
      print("loggedinUser");
      print(loggedinUser);
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getMessages() async {
    var messages = await _firestore.collection('messages').get();
    for(var message in messages.docs){

    }
  }

  void getMessageStream() async {
    await  for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){

      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // getMessageStream();
                _auth.signOut();
                Navigator.pushNamed(context, Login.id);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor:  const Color.fromRGBO(255, 100, 127, 1),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return  Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/3),
                        const CircularProgressIndicator(color:Color.fromRGBO(255, 100, 127, 1),),
                      ],
                    );
                  }
                  else{
                    var messages = snapshot.data;
                     print("messages!.docs");
                     print(messages!.docs);
                    List<MessageBubble> messageBubble = [];
                    for (var message in messages.docs){
                      var m =message.data;
                      final mText = (message.data() as dynamic)['text'] ?? '';
                      final mSender = (message.data() as dynamic)['sender'] ?? '';
                      bool isMe=false;
                      if ( loggedinUser!.email == mSender){
                        isMe = true;
                      }
                      messageBubble.add(MessageBubble(text: mText, email: mSender,isMe: isMe,));
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                        children: messageBubble,
                      ),
                    );
                  }

            }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        text = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': text,
                        'sender': loggedinUser!.email
                      });
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text,required this.email,required this.isMe});

  final String text;
  final String email;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    // print(isMe);
    return Padding(padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            email,
          style: const TextStyle(),
          ),
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            color: isMe? Colors.white : Colors.lightBlue ,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe? Colors.black : Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
    ),
    );
  }
}
