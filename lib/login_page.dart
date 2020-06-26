import 'package:flutter/material.dart';

import 'authentication.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isLoading;
  String _email,_password,_errorMessage,_username;

  @override
  void initState() {
    _errorMessage ="";
    _isLoading = false;
   // _isLoginForm = true;
    super.initState();
  }

  Widget _LoginForm(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showEmailInput(),
            showPasswordInput(),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                  height: 40.0,
                  child: RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      color: Colors.blue,
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 20.0,color: Colors.white
                          )),
                      onPressed: loginvalidateAndSubmit
                  ),
                ),
            ),
            FlatButton(
                child: Text('Dont have an account? Create Account',
                    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300)),
                onPressed: _SignUpForm
            ),
            showErrorMessage()
          ],
        ),
      ),
    );
  }

  Widget _SignUpForm(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showUsernameInput(),
            showEmailInput(),
            showPasswordInput(),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
              child: SizedBox(
                height: 40.0,
                child: RaisedButton(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                    ),
                    color: Colors.blue,
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontSize: 20.0,color: Colors.white
                        )),
                    onPressed: signupvalidateAndSubmit
                ),
              ),
            ),
            FlatButton(
                child: Text('Already have an account? Sign In',
                    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w300)),
                onPressed: (){
                },
            ),
            showErrorMessage()
          ],
        ),
      ),
    );
  }


  void loginvalidateAndSubmit() async {
    setState(() {
      _errorMessage ="";
      // _isLoading = true;
    });
    if(validateAndSave()){
    String userId = "";
    try{
      userId = await widget.auth.signIn(_email, _password);
      print('Signed innnnnnnnnn : $userId');
      setState(() {
        _isLoading = false;
      });

      if(userId.length > 0 && userId != null) {
        widget.loginCallback();
      }
      } catch(e) {
        print('error messaaggeeee : $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void signupvalidateAndSubmit() async {
    setState(() {
      _errorMessage ="";
      // _isLoading = true;
    });
    if(validateAndSave()){
      String userId = "";
      try{
        userId = await widget.auth.signUp(_email, _password);
        print('Signed upppppp: $userId');
        setState(() {
          _isLoading = false;
        });

        if(userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch(e) {
        print('error messaaggeeee : $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }


  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  Widget showErrorMessage(){
    if(_errorMessage.length > 0 && _errorMessage != null){
      return Text(_errorMessage,style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300
      ),);
    }else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showUsernameInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
            hintText: "User Name",
            icon: Icon(Icons.account_circle,color: Colors.grey)
        ),
        validator: (value) => value.isEmpty ? 'Username cannot be empty' : null,
        onSaved: (value) => _username = value.trim(),
      ),
    );
  }

  Widget showEmailInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
            hintText: "Email",
            icon: Icon(Icons.mail,color: Colors.grey)
        ),
        validator: (value) => value.isEmpty ? 'Email cannot be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: "Password",
            icon: Icon(Icons.lock,color: Colors.grey)
        ),
        validator: (value) => value.isEmpty ? 'Password cannot be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: Stack(
        children: <Widget>[
          _SignUpForm(),
          showCircularProgress(),
        ],
      ),
    );
  }
}
