import 'package:flutter/material.dart';
import 'package:imdb_clone/account.dart';
import 'package:imdb_clone/home.dart';
import 'package:imdb_clone/search.dart';
import 'package:imdb_clone/video.dart';

class NavStatefulWidget extends StatefulWidget {
  const NavStatefulWidget({Key? key}) : super(key: key);

  @override
  State<NavStatefulWidget> createState() => _NavStatefulWidgetState();
}

class _NavStatefulWidgetState extends State<NavStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    SearchWidget(),
    VideoWidget(),
    AccountWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
