import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newww/widget.dart';
import 'constants.dart';
import 'conversation_screen.dart';
import 'database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"],
          );
        }) : Container();
  }

  createChatroomAndStartConversation({String userName}){
    print("$userName searching persson nameeeeeeeeeeeeee");
    if(userName != Constants.myName){
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users" : users,
        "chatroomId" : chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)
      ));
    } else {
      print("you cannt send msg to urself");
    }
  }

  Widget SearchTile({String userName, String userEmail}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 15),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(userName,style: mediumTextStyle(),),
                Text(userEmail,style: mediumTextStyle(),)
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                createChatroomAndStartConversation(userName: userName);

              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: Text("Message",style: mediumTextStyle(),),
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "search username....",
                            hintStyle: TextStyle(
                                color: Colors.white54
                            ),
                            border: InputBorder.none
                        ),
                      )),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF),
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Image.asset("assets/images/search.jpg")),
                  ),

                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}