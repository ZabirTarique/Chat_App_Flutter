
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants.dart';
import 'login_screen.dart';
class ChatScreen extends StatefulWidget {
  static String id = '/chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  late User loggedinUser;
  late String text;
  var _firestore = FirebaseFirestore.instance;
  var messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser() async {
    final User user = await _auth.currentUser!;
    try{
      if(user != null){
        loggedinUser = user;
        print(loggedinUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  void getMessages() async {
    var messages = await _firestore.collection('messages').get();
    for(var message in messages.docs){
      print(message.data());

    }
  }

  void getMessageStream() async {
    await  for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data());

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
              icon: Icon(Icons.close),
              onPressed: () {
                // getMessageStream();
                _auth.signOut();
                Navigator.pushNamed(context, LoginScreen.id);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
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
                    return Center(child: CircularProgressIndicator(),);
                  }
                  var messages = snapshot.data;
                  // print(messages!.docs);
                  List<MessageBubble> messageBubble = [];
                  for (var message in messages!.docs){
                    var m =message.data;
                    final mText = (message.data() as dynamic)['text'] ?? '';
                    final mSender = (message.data() as dynamic)['sender'] ?? '';
                    bool isMe=false;
                    if ( loggedinUser.email == mSender){
                      isMe = true;
                    }
                    print('IsMe: '+isMe.toString());
                    messageBubble.add(MessageBubble(text: mText, email: mSender,isMe: isMe,));
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageBubble,
                    ),
                  );
                  // var messages = snapshot.data.toString();
                  // List<Text> textWidgetList = [];
                  // for (var message in messages?? ){
                  //
                  // }
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
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': text,
                        'sender': loggedinUser.email
                      });
                      //Implement send functionality.
                    },
                    child: Text(
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
    return Padding(padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            email,
          style: TextStyle(),
          ),
          Material(
            borderRadius: BorderRadius.circular(10.0),
            elevation: 5.0,
            color: isMe? Colors.white : Colors.lightBlue ,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
