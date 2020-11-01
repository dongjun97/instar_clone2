import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instar_clone2/login_page.dart';
import 'package:instar_clone2/tab_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(//데이터를 받앗을때 변경
      stream: FirebaseAuth.instance.authStateChanges(),//인증이 되거나 끊어짐을 확인
      builder: (BuildContext context, AsyncSnapshot snapshot){//snapshot firebase유저정보
        if(snapshot.hasData){//데이터가 있다면
          return TabPage(snapshot.data);//dynamic 타입 Object느낌
        } else{
          return LoginPage();
        }
      },
    );
  }
}