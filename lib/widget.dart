import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
      title: Text("Amina's Chat App")
  );
}

InputDecoration textFieldInputDecoration(String hinttext){
  return InputDecoration(
      hintText : hinttext,
      hintStyle : TextStyle(color: Colors.white),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 16
  );
}

TextStyle mediumTextStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );
}