// ignore_for_file: use_super_parameters, must_be_immutable, prefer_typing_uninitialized_variables, deprecated_member_use


import 'package:flutter/material.dart';
import '../component/stayinapp.dart';
import '../shared/colors.dart';
import 'compte/account.dart';
import 'home/home.dart';
import 'recette/switch.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key? key, this.value}) : super(key: key);
  int? value;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  late int _selectedIndex;
  bool exitValue = true;
  late var screens;
  double sizeIcons = 25.0;
  int id = 0;

  @override
  void initState() {
    if (widget.value != null) {
      setState(() {
        _selectedIndex = widget.value!;
      });
    } else {
      _selectedIndex = 0;
    }
    screens = [const HomePage(), const SwitchPage(), const AccountPage()];
    super.initState();
  }


  exit(){
    setState(() {
      exitValue = true ;
    });
    debugPrint(exitValue.toString()) ;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {
            onWillPopUp(context,exit);
            debugPrint(exitValue.toString()) ;
            return exitValue;

        } else {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: screens),
        bottomNavigationBar: barNavigationBottom(),
      ),
    );
  }

  Widget barNavigationBottom() {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        elevation: 6,
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        backgroundColor: noir(),
        selectedItemColor: orange(),
        unselectedItemColor: orangeLight(),
        selectedFontSize: 15,
        showSelectedLabels: false,
        unselectedFontSize: 12,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/icon/home.png"),
                size: sizeIcons,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/icon/recette.png"),
                size: sizeIcons,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage("assets/icon/account.png"),
                size: sizeIcons,
              ),
              label: '')
        ]);
  }
}
