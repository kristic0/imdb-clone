import 'package:flutter/material.dart';
import 'package:imdb_clone/account.dart';
import 'package:imdb_clone/home.dart';
import 'package:imdb_clone/profile_page.dart';
import 'package:imdb_clone/search.dart';
import 'package:imdb_clone/tab_item.dart';
import 'package:imdb_clone/video.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context) {
    var routeBuilders = _homeRouteBuilder(context);

    switch (tabItem) {
      case TabItem.home:
        routeBuilders = _homeRouteBuilder(context);
        break;
      case TabItem.search:
        routeBuilders = _searchRouteBuilder(context);
        break;
      case TabItem.account:
        routeBuilders = _accountRouteBuilder(context);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.detail]!(context),
      ),
    );
  }

  Map<String, WidgetBuilder> _homeRouteBuilder(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => Scaffold(
            body: HomeWidget(),
          ),
    };
  }

  Map<String, WidgetBuilder> _searchRouteBuilder(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => Scaffold(
            body: SearchWidget(),
          ),
    };
  }

  Map<String, WidgetBuilder> _accountRouteBuilder(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => Scaffold(
            body: AccountWidget(),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _homeRouteBuilder(context);

    switch (tabItem) {
      case TabItem.home:
        routeBuilders = _homeRouteBuilder(context);
        break;
      case TabItem.search:
        routeBuilders = _searchRouteBuilder(context);
        break;
      case TabItem.account:
        routeBuilders = _accountRouteBuilder(context);
        break;
    }

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}
