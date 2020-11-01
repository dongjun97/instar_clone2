import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instar_clone2/create_page.dart';

import 'detail_post_page.dart';

class SearchPage extends StatefulWidget {//stateful
  final User user;

  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buidBody(),
      floatingActionButton: FloatingActionButton(//글쓰기 아이콘 버튼
        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreatePage(widget.user)));
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buidBody() {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),//post밑에 데이터가 들어오는것을 반응
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(!snapshot.hasData){//데이터가 없다면
            return Center(child: CircularProgressIndicator());//로딩화면 가운데 빙글도는거
          }

          var items = snapshot.data?.documents ?? [];//데이터가 있다면 .document 아니면 null은 []

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,//열의개수
                  childAspectRatio: 1.0,//이미지 가로세로 비율
                  mainAxisSpacing: 1.0,//미세공간
                  crossAxisSpacing: 1.0
              ),
              itemCount: items.length,
              itemBuilder: (context, index){
                return _buildListItem(context, items[index]);
              });
        },
      ),
    );
  }



  Widget _buildListItem(context, document) {
    return Hero(//눌렀을때 커지는 느낌
      tag: document['photoUrl'],//tag설정
      child: Material(
        child: InkWell(//눌렸을때 효과
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return DetailPostPage(document);
            }));
          },
          child: Image.network(
              document['photoUrl'],
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
