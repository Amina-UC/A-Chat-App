import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newww/authentication.dart';
import 'package:newww/helperfunctions.dart';

import 'database.dart';
import 'widget.dart';

class LoginSignupPage extends StatefulWidget {

  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  DatabaseMethods databasemethods = new DatabaseMethods();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading;
  String _email,_isLoginForm,_password,_username,_errorMessage;

  @override
  void initState() {
    _errorMessage ="";
    _isLoading = false;
    _isLoginForm = "login";
    super.initState();
  }

  void resetForm(){
    _formKey.currentState.reset();
    _errorMessage="";
  }


  //check if form is valid beforebperform login or signup
  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget showCircularProgress(){
    if(_isLoading){
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showUsernameInput(){
    if(_isLoginForm == "signup"){
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          style: TextStyle(color: Colors.white,
              fontSize: 16),
          autofocus: false,
          decoration: InputDecoration(
              icon: Icon(Icons.account_circle,color: Colors.white),
              hintText : "username",
              hintStyle : TextStyle(color: Colors.white),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              )
          ),
          validator: (value) =>
          value.isEmpty
              ? 'Username cannot be empty'
              : null,
          onSaved: (value) => _username = value.trim(),
        ),

      );
    } else {
      return Container();}
  }


  Widget showEmailInput(){
    return Padding(
      padding: _isLoginForm =="login" || _isLoginForm =="reset" ? const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0) : const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: TextFormField(
        maxLines: 1,
      style: TextStyle(color: Colors.white,
          fontSize: 16),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText : "email",
          hintStyle : TextStyle(color: Colors.white),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          ),
          icon: Icon(Icons.email,color: Colors.white),
        ),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  bool _isPassHidden = true;
  void _togglePassVisibility(){
    setState(() {
      _isPassHidden = !_isPassHidden;
    });
  }

  Widget showPasswordInput(){
    if(_isLoginForm=="login" || _isLoginForm=="signup") {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          style: TextStyle(color: Colors.white,
              fontSize: 16),
          obscureText: _isPassHidden,
          autofocus: false,
          decoration: InputDecoration(
            icon: Icon(Icons.lock, color: Colors.white),
            suffixIcon: IconButton(onPressed: _togglePassVisibility,
                icon: _isPassHidden ? Icon(Icons.visibility_off) : Icon(
                    Icons.visibility),
                color: Colors.white),
            hintText: "password",
            hintStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),

          ),
          validator: (value) =>
          value.isEmpty
              ? 'Password cannot be empty'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
      );
    }else{
      return Container();
    }
  }

  Widget showPrimaryButton(){
    return GestureDetector(
      onTap: (){
        validateAndSubmit();
      },
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC)
                  ]
              ),
              borderRadius: BorderRadius.circular(30)
          ),
              child: Text(_isLoginForm=="login" ? 'Login' : _isLoginForm=="signup" ? 'Sign Up' : "Reset Password",
                  style: TextStyle(
                      fontSize: 20.0,color: Colors.white
                  )),
          ),
        );
  }

  QuerySnapshot snapshotuserinfo;
  //perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage ="";
     // _isLoading = true;
    });
    if(validateAndSave()){
      String userId = "";
      try{
        if(_isLoginForm=="login") {
          userId = await widget.auth.signIn(_email, _password);
          databasemethods.getUserByUserEmail(_email).
          then((val){
            snapshotuserinfo = val;
            HelperFunctions.saveUserNameSharedPreference(snapshotuserinfo.documents[0].data["name"]);
          });
          HelperFunctions.saveUserEmailSharedPreference(_email);
          print('Signed in: $userId');
        }else if(_isLoginForm=="signup"){
          userId = await widget.auth.signUp(_email, _password);
          Map<String, String> userInfoMap = {

              "name": _username,
              "email": _email
            };
            databasemethods.uploadUserInfo(userInfoMap);
            HelperFunctions.saveUserNameSharedPreference(_username);
            HelperFunctions.saveUserEmailSharedPreference(_email);
          print('Signed up user: $userId');
        }else
          {
          await widget.auth.sendPasswordResetEmail(_email);
          print("password reset email sent");
          _errorMessage= "A password reset link has been sent to $_email";
          setState(() {
            _isLoginForm = "login";
          });
        }
        setState(() {
          _isLoading = false;
        });
        if(userId.length > 0 && userId != null ) {
          widget.loginCallback();
        }
      } catch(e) {
        print('error messaaggeeee : $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;

        });
      }
    }
  }



  Widget showSecondaryButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_isLoginForm=="login" ? "Dont have an account?  " : _isLoginForm=="signup" ? "Already have account?  " : "Return to  ",style: TextStyle(
        color: Colors.white,
        fontSize: 17)),
        GestureDetector(
          onTap: (){
            toggleFormMode();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(_isLoginForm=="login" ?  "Create account" : _isLoginForm=="signup" ? "SignIn now" : "Sign In",style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                decoration: TextDecoration.underline
            ),),
          ),
        )
      ],
    );
  }

  void toggleFormMode() {
    if(_isLoginForm=="login"){
    resetForm();
    setState(() {
      _isLoginForm =  "signup";
    });
    }
    else if(_isLoginForm=="signup" || _isLoginForm=="reset"){
      resetForm();
      setState(() {
        _isLoginForm =  "login";
      });
    }else{
      resetForm();
      setState(() {
        _isLoginForm =  "login";
      });
    }
  }

  Widget showErrorMessage(){
    if(_errorMessage.length > 0 && _errorMessage != null){
      return Dismissible(
        key: Key("warning msg"),
        child: Container(
          color: Colors.yellow,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          child: Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline,color: Colors.black,),
            ),
            Expanded(
              child: ListTile(
                title: Text(_errorMessage,style: TextStyle(fontSize: 16), maxLines: 3),
                subtitle: Text("<<--- Swipe to remove --->>",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.red),),
              ),
            ),
          ],),
        ),
        direction: DismissDirection.horizontal,
      );
    }else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget fogotPassword(){
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showEmailInput(),
              SizedBox(height: 15,),
              showPrimaryButton(),
              SizedBox(height: 15,),
              showSecondaryButton(),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );

  }

  Widget showFogotPassword(){
  if(_isLoginForm == "login"){
  return GestureDetector(
    onTap:(){setState(() {
      _isLoginForm = "reset";
    });
      _showForm();
      },
    child: Container(
    alignment: Alignment.centerRight,
    child: Container(
    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
    child: Text("Forgot Password?",style: TextStyle(
    color: Colors.white,
    fontSize: 16
    ),),
    ),
    ),
  );
  }else{
    return Container();
  }
  }

  Widget _showForm(){
    return Container(
      height: MediaQuery.of(context).size.height - 50,
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showUsernameInput(),
              showEmailInput(),
              showPasswordInput(),
              SizedBox(height: 15,),
              showFogotPassword(),
              SizedBox(height: 15,),
              showPrimaryButton(),
              SizedBox(height: 15,),
              showSecondaryButton(),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: <Widget>[
          showErrorMessage(),
          _showForm(),
          showCircularProgress(),
        ],
      ),
    );
  }
}
