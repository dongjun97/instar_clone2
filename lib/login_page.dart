import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';//구글 로그인
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();//구글로그인 객체
  final FirebaseAuth _auth = FirebaseAuth.instance;//인증을 위한 인스턴스를 통해 객체를 얻음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Insta Clone',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(50.0),
            ),
            SignInButton(Buttons.Google, onPressed: () {
              _handleSignIn().then((user){//비동기처리하는법 then
                print(user);
              });
            })
          ],
        ),
      ),
    );
  }
/*
  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = (await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))).user;
    print("signed in " + user.displayName);
    return user;
  }
 */

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    User user = (await _auth.signInWithCredential(//firebase 연결하기위함
        GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))).user;//아이디 access
    print("signed in " + user.displayName);
    return user;
  }
}
