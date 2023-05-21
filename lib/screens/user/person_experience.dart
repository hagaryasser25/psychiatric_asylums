import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/models/person_exp.dart';
import 'package:psychiatric_asylums/screens/user/add_exp.dart';

import '../models/users_model.dart';

class PersonExperience extends StatefulWidget {
  const PersonExperience({super.key});

  @override
  State<PersonExperience> createState() => _PersonExperienceState();
}

class _PersonExperienceState extends State<PersonExperience> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  late Users currentUser;
  List<Exp> expList = [];
  List<String> keyslist = [];

  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchExp();
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

  void fetchExp() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("personExp");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Exp p = Exp.fromJson(event.snapshot.value);
      expList.add(p);
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
                  child: Text('التجارب الشخصية'),
                ))),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 40.h, left: 10.w),
              child: FloatingActionButton(
                backgroundColor: HexColor('#b4a7d6'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddExp(
                      name: '${currentUser.fullName}',
                    );
                  }));
                },
                child: Icon(Icons.add),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 10,
                left: 10,
              ),
              child: ListView.builder(
                itemCount: expList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 15, left: 15, bottom: 10),
                        child: Column(children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'اسم المريض : ${expList[index].name.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'التجربة : ${expList[index].status.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'النتيجة : ${expList[index].result.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                        ]),
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
