import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/add_essay.dart';
import 'package:psychiatric_asylums/screens/admin/admin_essay.dart';
import 'package:psychiatric_asylums/screens/models/essay_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../auth/login.dart';
import '../models/users_model.dart';

class UserHome extends StatefulWidget {
  static const routeName = '/userHome';
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Essay> essayList = [];
  List<String> keyslist = [];
  late Users currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEssay();
    getUserData();
  }

  void fetchEssay() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("essay");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Essay p = Essay.fromJson(event.snapshot.value);
      essayList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  getUserData() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await base.get();
    setState(() {
      currentUser = Users.fromSnapshot(snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
              toolbarHeight: 80.0,
              backgroundColor: HexColor('#b4a7d6'),
              title: Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Text('مقالات عن الادمان'),
              ))),
          drawer: Drawer(
            child: FutureBuilder(
              future: getUserData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (currentUser == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: HexColor('#b4a7d6'),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 18.h,),
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("معلومات المستخدم",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                        ),
                        title: const Text('اسم المستخدم'),
                        subtitle: Text('${currentUser.fullName}'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.email,
                        ),
                        title: const Text('البريد الالكترونى'),
                        subtitle: Text('${currentUser.email}'),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.phone,
                        ),
                        title: const Text('رقم الهاتف'),
                        subtitle: Text('${currentUser.phoneNumber}'),
                      ),
                      Divider(
                        thickness: 0.8,
                        color: Colors.grey,
                      ),
                      Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              child: ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('تأكيد'),
                                          content: Text(
                                              'هل انت متأكد من تسجيل الخروج'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                FirebaseAuth.instance.signOut();
                                                Navigator.pushNamed(context,
                                                    LoginPage.routeName);
                                              },
                                              child: Text('نعم'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('لا'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                title: Text('تسجيل الخروج'),
                                leading: Icon(Icons.exit_to_app_rounded),
                              )))
                    ],
                  );
                }
              },
            ),
          ),
          body: Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: StaggeredGridView.countBuilder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 20.h,
                        left: 15.w,
                        right: 15.w,
                        bottom: 15.h,
                      ),
                      crossAxisCount: 6,
                      itemCount: keyslist.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AdminEssay(
                                  title: keyslist[index],
                                );
                              }));
                            },
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                child: Center(
                                  child: Column(children: [
                                    SizedBox(
                                      height: 100.h,
                                    ),
                                    Text(
                                      '${keyslist[index]}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: HexColor('#b4a7d6')),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(3, index.isEven ? 3 : 3),
                      mainAxisSpacing: 35.0,
                      crossAxisSpacing: 5.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
