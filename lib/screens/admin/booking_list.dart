import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:psychiatric_asylums/screens/models/list_model.dart';
import 'dart:ui' as ui;

class BookingList extends StatefulWidget {
  static const routeName = '/bookingList';
  const BookingList({Key? key}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<BookingListV> bookingList = [];
  List<String> keyslist = [];
  String request = 'false';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchList();
    
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(request);
  }
  @override
  void fetchList() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("asylumsBookings");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      BookingListV p = BookingListV.fromJson(event.snapshot.value);
      bookingList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
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
                  child: Text('قائمة التقديمات فى المصحات'),
                ))),
            body: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 10,
                left: 10,
              ),
              child: ListView.builder(
                itemCount: bookingList.length,
                itemBuilder: (BuildContext context, int index) {
                  var date = bookingList[index].date;
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
                                'كود المريض : ${bookingList[index].userCode.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'اسم المريض : ${bookingList[index].userName.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'كود المصحة : ${bookingList[index].asylumCode.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'اسم المصحة : ${bookingList[index].asylumName.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'تاريخ التقديم : ${getDate(date!)}',
                                style: TextStyle(fontSize: 17),
                              )),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'وصف الحالة : ${bookingList[index].status.toString()}',
                                style: TextStyle(fontSize: 17),
                              )),
                          SizedBox(
                            height: 15.h,
                          ),
                          request == 'false'
                              ? Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 120.w, height: 35.h),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: HexColor('#b4a7d6'),
                                        ),
                                        child: Text('قبول الحجز'),
                                        onPressed: () {
                                          setState(() {
                                            request = 'true';
                                            print(request);
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content:
                                                      Text('تم قبول الطلب'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    super
                                                                        .widget));
                                                      },
                                                      child: Text("حسنا"),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70.w,
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: 120.w, height: 35.h),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: HexColor('#b4a7d6'),
                                        ),
                                        child: Text('حذف الحجز'),
                                        onPressed: () async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('asylumsBookings')
                                              .child(
                                                  '${bookingList[index].id.toString()}')
                                              .remove();
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: 120.w, height: 35.h),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: HexColor('#b4a7d6'),
                                    ),
                                    child: Text('حذف الحجز'),
                                    onPressed: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget));
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('asylumsBookings')
                                          .child(
                                              '${bookingList[index].id.toString()}')
                                          .remove();
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: 30.h,
                          )
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

  String getDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);

    return DateFormat('MMM dd yyyy').format(dateTime);
  }
}
