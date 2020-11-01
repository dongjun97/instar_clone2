import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  final User user;

  CreatePage(this.user);
   @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {//화면이 없어질때 해줘야함 close느낌
    textEditingController.dispose();
    super.dispose();
  }

  File _image; //import dart.io

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(onPressed: _getImage,
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Center(child: Text('새 게시물')),
      actions: <Widget> [
        IconButton(icon: Icon(Icons.send), onPressed: (){
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()//시작점
              .child('post')//post라는 directiory
              .child('${DateTime.now().millisecondsSinceEpoch}.png');//사진파일 이름 현재시간으로 이름
          final task = firebaseStorageRef.putFile(//파일업로드
              _image, StorageMetadata(contentType: 'image/png')//이미지와 이미지의 정보
          );
          task.onComplete.then((value) {//완료후
            var downloadUrl =  value.ref.getDownloadURL();//데이터의 주소 다운을 위한

            downloadUrl.then((uri) {//다운로드 경로
              var doc = FirebaseFirestore.instance.collection('post');//post가 없으면 만들겠다
              doc.add({//map을 json형태로 넣음
                'id': doc.id,//생성전에 아이00디를 알수있음
                'photoUrl': uri.toString(),
                'contents': textEditingController.text,//텍스트값
                'email': widget.user.email,//user정보 중 이메일
                'displayName': widget.user.displayName,//user정보 중 이름
                'userPhotoUrl': widget.user.photoURL//user정보 중
              }).then((onValue){
                Navigator.pop(context);//화면을 닫음
              });
            });
          });
         })
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(//화면이 넘어갈수도잇기때문에 스크롤 생성
      child: Column(
        children: <Widget> [
          _image == null ? Text('No Image') : Image.file(_image),//이미지가 null이면앞 아니면 이미지들
          TextField(//텍스트작업
            decoration: InputDecoration(hintText: '내용을 입력하시오'),//힌트주기
            controller: textEditingController,//텍스트값을 얻어오기위함
          )
        ],
      ),
    );
  }

  Future _getImage() async {//기다렸다가 클릭시 변경
    //var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var image = await ImagePicker().getImage(source: ImageSource.gallery);//갤러리에서 가져오겠다
    //await 나중에 future에 넘겨주겠다 file형태로 만들려면 await붙임

    setState(() {//눌렸을때 변경
      //_image = image;
      _image = File(image.path);
    });
  }
}
