import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/add_essay.dart';
import 'package:psychiatric_asylums/screens/auth/login.dart';
import 'package:psychiatric_asylums/screens/models/essay_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import 'admin_essay.dart';

class AdminHome extends StatefulWidget {
  static const routeName = '/adminHome';
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Essay> essayList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchEssay();
  }

  @override
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 80.0,
            backgroundColor: HexColor('#b4a7d6'),
            title: Center(
                child: Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Text('مقالات عن الادمان'),
            )),
            actions: [
              IconButton(
                color: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('تأكيد'),
                          content: Text('هل انت متأكد من تسجيل الخروج'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushNamed(
                                    context, LoginPage.routeName);
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
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 40.h, left: 10.w),
            child: FloatingActionButton(
              backgroundColor: HexColor('#b4a7d6'),
              onPressed: () {
                Navigator.pushNamed(context, AddEssay.routeName);
              },
              child: Icon(Icons.add),
            ),
          ),
          body: SingleChildScrollView(
            child: Material(
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
                                    Image.asset('assets/images/essay.png', width: 100.w,height: 100.h),
                                    SizedBox(height: 20.h,),
                                    Text(
                                      '${keyslist[index]}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: HexColor('#b4a7d6')),
                                    ),
                                    SizedBox(height: 20.h,),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    super.widget));
                                        base.child(keyslist[index]).remove();
                                      },
                                      child: Icon(Icons.delete,
                                          color: HexColor('#b4a7d6')),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(3, index.isEven ? 3 : 3),
                      mainAxisSpacing: 25.0,
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
