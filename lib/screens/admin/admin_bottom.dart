import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/admin_asylums.dart';
import 'package:psychiatric_asylums/screens/admin/admin_exp.dart';
import 'package:psychiatric_asylums/screens/admin/admin_home.dart';
import 'package:psychiatric_asylums/screens/admin/admin_videos.dart';
import 'package:psychiatric_asylums/screens/admin/booking_list.dart';
import 'package:psychiatric_asylums/screens/auth/login.dart';
import 'package:psychiatric_asylums/screens/user/user_home.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List _pages;
  int _selectedPageIndex = 0;
  @override
  void initState() {
    _pages = [
      {
        'page': AdminHome(),
      },
      {
        'page': AdminVideos(),
      },
      {
        'page': AdminAsylums(),
      },
      {
        'page': BookingList(),
      },
      {
        'page': AdminExperience(),
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
                    Icons.list,
                  ),
                  label: 'booking list',
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
