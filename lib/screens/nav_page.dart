import 'package:flutter/material.dart';
import 'package:inventoryapp/screens/category_add.dart';
import 'package:inventoryapp/screens/category_page.dart';
import 'package:inventoryapp/screens/home_page.dart';
import 'package:inventoryapp/screens/main_page.dart';
import 'package:inventoryapp/screens/test.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  // int _selectedIndex = 0;

  // void _navigateBottomBar(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  // final List<Widget> _pages = [
  //   CategoryPage(),
  //   CategoryAdd(),
  // ];

  List<Widget> _buildScreens() {
        return [
          HomePage(),
          CategoryPage(),
          MainPage()
        ];
    }

  List<PersistentBottomNavBarItem> _navBarsItems() {
        return [
            PersistentBottomNavBarItem(
                icon: Icon(Icons.home),
                title: ("Home"),
                activeColorPrimary: Colors.green,
                inactiveColorPrimary: Colors.grey,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.settings),
                title: ("Settings"),
                activeColorPrimary: Colors.green,
                inactiveColorPrimary: Colors.grey,
            ),
            PersistentBottomNavBarItem(
                icon: Icon(Icons.sailing),
                title: ("Settings"),
                activeColorPrimary: Colors.green,
                inactiveColorPrimary: Colors.grey,
            ),
        ];
    }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: false, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 150),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}