import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/admin_asylums.dart';
import 'package:psychiatric_asylums/screens/admin/admin_home.dart';
import 'package:psychiatric_asylums/screens/admin/admin_videos.dart';
import 'package:psychiatric_asylums/screens/auth/login.dart';
import 'package:psychiatric_asylums/screens/user/person_experience.dart';
import 'package:psychiatric_asylums/screens/user/user_asylums.dart';
import 'package:psychiatric_asylums/screens/user/user_home.dart';
import 'package:psychiatric_asylums/screens/user/user_videos.dart';

class BottomBarUser extends StatefulWidget {
  static const routeName = '/BottomBarUser';
  const BottomBarUser({Key? key}) : super(key: key);

  @override
  State<BottomBarUser> createState() => _BottomBarUserState();
}

class _BottomBarUserState extends State<BottomBarUser> {
  late List _pages;
  int _selectedPageIndex = 0;
  @override
  void initState() {
    _pages = [
      {
        'page': UserHome(),
      },
      {
        'page': UserVideos(),
      },
      {
        'page': UserAsylums(),
      },
      {
        'page': PersonExperience(),
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Colors.white,
              unselectedItemColor: HexColor('#C0C0C0'),
              selectedItemColor: HexColor('#b4a7d6'),
              currentIndex: _selectedPageIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home'
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_call),
                  label: 'videos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.local_hospital,
                  ),
                  label: 'asylums',
                ),
                 BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'person experience',
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
