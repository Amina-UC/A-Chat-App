import 'package:flutter/material.dart';

import 'authentication.dart';
import 'constants.dart';
import 'conversation_screen.dart';
import 'database.dart';
import 'helperfunctions.dart';
import 'search_screen.dart';
import 'widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key,this.auth,this.userId,this.logoutCallback});
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseMethods databaseMethods =new DatabaseMethods();
  Stream chatRoomStream;

  signOut() async {
    try{
      await widget.auth.signOut();
      widget.logoutCallback();
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {

    });
  }

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                  snapshot.data.documents[index].data["chatroomId"]
                      .toString().replaceAll("_", "").replaceAll(Constants.myName,""),
                  snapshot.data.documents[index].data["chatroomId"]
              );
            }) : Container();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app,color: Colors.white),
          onPressed: signOut
            ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {

  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",style: mediumTextStyle(),),
            ),
            SizedBox(width: 12,),
            Text(userName,style: mediumTextStyle(),)
          ],
        ),
      ),
    );
  }
}
