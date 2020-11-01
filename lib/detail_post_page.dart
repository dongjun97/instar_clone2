import 'package:flutter/material.dart';

class DetailPostPage extends StatelessWidget {
  final dynamic document;//final은 var같이 못씀

  DetailPostPage(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('둘러보기'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
        child: SingleChildScrollView(//스크롤
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,//왼쪽으로부터
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(document['userPhotoUrl']),
                    ),
                    Padding(padding: EdgeInsets.only(left: 8.0),//한군데만 가능
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            document['email'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(document['displayName'])
                        ],
                      ),)
                  ],
                ),
              ),
              Hero(
                  tag: document['photoUrl'],
                  child: Image.network(document['photoUrl'])),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(document['contents']),
              )
            ],
          ),
        )
    );
  }
}
