import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_chat/home.dart';


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool pageInitialised = false; // מאותחל
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    checkIfUserLoggedIn();
    // TODO: implement initState
    super.initState();
  }

  checkIfUserLoggedIn()async{
    SharedPreferences sharedPreferences; await SharedPreferences.getInstance();
    bool userLoggedIn = sharedPreferences.getBool("ID") ?? false;

    if (userLoggedIn) {
      Navigator.of(context)
          .push (MaterialPageRoute (builder: (context) => Home()));
    }else{
      pageInitialised = true;
    }
  }

  handleSignIn()async{
    final res = await googleSignIn.signIn(); // Get google response
    final auth = await res.authentication; // Get auth response
    final credentials = GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken); // Embed details
    final firebaseUser = (await firebaseAuth.signInWithCredential(credentials)).user; // Get user data by details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageInitialised ? Center(
        child: ElevatedButton(
          child: Text("Sign In"),
          onPressed: () {

          },
      ),
    )
    : Center(child:
    CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors .blue),
        ),
      )
    );
  }
}
