import 'package:flutter/material.dart';
import 'package:imdb_clone/account.dart';
import 'package:imdb_clone/home.dart';
import 'package:imdb_clone/search.dart';
import 'package:imdb_clone/tab_item.dart';
import 'package:imdb_clone/tab_navigator.dart';
import 'package:imdb_clone/video.dart';

class NavStatefulWidget extends StatefulWidget {
  const NavStatefulWidget({Key? key}) : super(key: key);

  @override
  State<NavStatefulWidget> createState() => _NavStatefulWidgetState();
}

class _NavStatefulWidgetState extends State<NavStatefulWidget> {
  int _selectedIndex = 0;
  TabItem _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem] ?? GlobalKey<NavigatorState>(),
        tabItem: tabItem,
      ),
    );
  }

  void _selectTab(TabItem tabItem, int idx) {
    if (tabItem == _currentTab) {
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final isFirstRouteInCurrentTab =
              !await _navigatorKeys[_currentTab]!.currentState!.maybePop();

          if (isFirstRouteInCurrentTab) {
            if (_currentTab != TabItem.home) {
              _selectTab(TabItem.home, 0);

              return false;
            }
          }
          return isFirstRouteInCurrentTab;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(TabItem.home),
              _buildOffstageNavigator(TabItem.search),
              _buildOffstageNavigator(TabItem.account),
            ],
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
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentTab.index,
            selectedItemColor: Colors.yellow[600],
            onTap: (int idx) {
              _selectTab(TabItem.values[idx], idx);
            },
          ),
        ));
  }
}
