import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/essay_model.dart';

class AdminEssay extends StatefulWidget {
  String title;
  static const routeName = '/adminEssay';
  AdminEssay({required this.title});

  @override
  State<AdminEssay> createState() => _AdminEssayState();
}

class _AdminEssayState extends State<AdminEssay> {
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
    base = database.reference().child("essay").child(widget.title);
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
            backgroundColor: HexColor('#b4a7d6'),
            title: Text(widget.title)
          ),
          body: Padding(
            padding: EdgeInsets.only(
              right: 5.w,
              left: 5.w,
              top: 5.h
            ),
            child: Text('${essayList[0].essay}',
            style: TextStyle(
              fontSize: 18
            ),),
          )
          
        ),
      ),
    );
  }
}