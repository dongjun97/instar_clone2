import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instar_clone2/account_page.dart';
import 'package:instar_clone2/home_page.dart';
import 'package:instar_clone2/search_page.dart';

class TabPage extends StatefulWidget {
  final User user;//로그인 정보

  TabPage(this.user);//로그인 정보 저장

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  List _pages;

  void initState(){
    super.initState();
    _pages =[
      HomePage(widget.user),//homepage
      SearchPage(widget.user),
      AccountPage(widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//꾸미기위함
      body: Center(child: _pages[_selectedIndex]),//pages[index] 화면 출력 가운데에 출력
      bottomNavigationBar: BottomNavigationBar(//하단 메뉴 바
        fixedColor: Colors.black,
          onTap: _onItemTapped,//누를시
          currentIndex: _selectedIndex,//선택 번호

          items: <BottomNavigationBarItem>[//리스트들
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), //home 0
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),//search 1
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),//account 2
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {//눌렀을경우
      _selectedIndex = index;//누른 메뉴에 해당하는 번호
    });
  }
}

