import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/add_asylum.dart';
import 'package:psychiatric_asylums/screens/models/asylums_model.dart';
import 'package:psychiatric_asylums/screens/user/book_asylums.dart';

import '../models/users_model.dart';

class UserAsylums extends StatefulWidget {
  static const routeName = '/userAsylums';
  const UserAsylums({super.key});

  @override
  State<UserAsylums> createState() => _UserAsylumsState();
}

class _UserAsylumsState extends State<UserAsylums> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Asylums> asylumsList = [];
  List<String> keyslist = [];
  late Users currentUser;

  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAsylums();
    getUserData();
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
  void fetchAsylums() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("asylums");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Asylums p = Asylums.fromJson(event.snapshot.value);
      asylumsList.add(p);
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
                child: Text('المصحات النفسية'),
              ))),
          body: Container(
            child: Padding(
              padding: EdgeInsets.only(
                top: 15.h,
                right: 10.w,
                left: 10.w,
              ),
              child: ListView.builder(
                  itemCount: asylumsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10.w),
                                  child: Container(
                                    width: 210.w,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${asylumsList[index].name.toString()}',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          overflow: TextOverflow.clip,
                                          'العنوان : ${asylumsList[index].address.toString()}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: HexColor('#999999')),
                                        ),
                                        Text(
                                          'المحافظة : ${asylumsList[index].governorate.toString()}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: HexColor('#999999')),
                                        ),
                                        Text(
                                          'رقم الهاتف : ${asylumsList[index].phoneNumber.toString()}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: HexColor('#999999')),
                                        ),
                                        RatingBar.builder(
                                          initialRating: asylumsList[index]
                                              .rating!
                                              .toDouble(),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate:
                                              (double rating2) async {
                                            rating2.toDouble();
                                            User? user = FirebaseAuth
                                                .instance.currentUser;

                                            if (user != null) {
                                              String uid = user.uid;
                                              int date = DateTime.now()
                                                  .millisecondsSinceEpoch;

                                              DatabaseReference companyRef =
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child('asylums')
                                                      .child(asylumsList[index]
                                                          .id
                                                          .toString());

                                              await companyRef.update({
                                                'rating': rating2,
                                              });
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 128.w, height: 40.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: HexColor('#b4a7d6'),
                                            ),
                                            child: Text('تقديم فى المصحة'),
                                            onPressed: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return BookAsylum(
                                                  asylumCode:
                                                      '${asylumsList[index].code.toString()}',
                                                  userCode: '${currentUser.uid}',
                                                  userName: '${currentUser.fullName}',
                                                  asylumName: '${asylumsList[index].name.toString()}',
                                                );
                                              }));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 110.w,
                                    height: 170.h,
                                    child: Image.network(
                                        '${asylumsList[index].imageUrl.toString()}')),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
