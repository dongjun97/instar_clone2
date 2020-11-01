import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatefulWidget {
  final User user;

  AccountPage(this.user);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  int _postCount = 0;//게시물 갯수

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('post').where('email', isEqualTo: widget.user.email)//widget의 이메일과 같다면
        .get()
        .then((snapShots){//정보
      setState(() {
        _postCount = snapShots.docs.length;//정보의 갯수 = 게시물의 갯수
      });
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(actions: <Widget>[
      IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            FirebaseAuth.instance.signOut();//firebase로그아웃
            _googleSignIn.signOut();//구글 로그아웃
          }),
    ]);
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,//맨위쪽에 위치
        mainAxisAlignment: MainAxisAlignment.spaceBetween,//모든컨텐츠들을 전체적으로 공간을 줌
        children: <Widget>[
          Column(//사진
            children: <Widget>[
              Stack(children: <Widget>[//이미지를 겹치기위해 stack
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2F20100113_10%2Fdbwjd177_12633924830421M1mY_jpg%2Fc6f7b8de2_yousongyee_dbwjd177.jpg&type=sc960_832'), //이미지 url
                  ),
                ),
                Container(
                    width: 80.0,
                    height: 80.0,//겹쳐야하기때문에 SizedBox와 사이즈를 맞춤
                    alignment: Alignment.bottomRight,//밑에 오른쪽에 배치
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(//뒤
                          width: 28.0,
                          height: 28.0,
                          child: FloatingActionButton(
                            onPressed: null,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(//앞
                          width: 25.0,
                          height: 25.0,
                          child: FloatingActionButton(//icon버튼
                            onPressed: null,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ))
              ]),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Text(
                widget.user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              )
            ],
          ),
          Text('$_postCount\n게시물',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),//text센터
          Text('0\n팔로워',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),
          Text('0\n폴로잉',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}
