import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:psychiatric_asylums/screens/user/bottom_user.dart';

class AddExp extends StatefulWidget {
  String name;
  static const routeName = '/addExp';
   AddExp({required this.name});

  @override
  State<AddExp> createState() => _AddExpState();
}

class _AddExpState extends State<AddExp> {
  var statusController = TextEditingController();
  var resultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 150.h,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 10,
                      controller: statusController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#b4a7d6'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'تجربتك',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 150.h,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 10,
                      controller: resultController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#b4a7d6'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'النتيجة',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: double.infinity, height: 65.h),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#b4a7d6'),
                      ),
                      onPressed: () async {
                        String status = statusController.text.trim();
                        String result = resultController.text.trim();

                        if (status.isEmpty) {
                          Fluttertoast.showToast(msg: 'ادخل تجربتك');
                          return;
                        }

                        if (result.isEmpty) {
                          Fluttertoast.showToast(msg: 'ادخل النتيجة');
                          return;
                        }

                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          String uid = user.uid;
                          int date = DateTime.now().millisecondsSinceEpoch;

                          DatabaseReference companyRef = FirebaseDatabase
                              .instance
                              .reference()
                              .child('personExp');

                          String? id = companyRef.push().key;

                          await companyRef.child(id!).set({
                            'id': id,
                            'status': status,
                            'result': result,
                            'name': widget.name,
                          });
                        }
                        showAlertDialog(context);
                      },
                      child: Text('حفظ'),
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

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: HexColor('#6bbcba'),
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, BottomBarUser.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم أضافة التجربة"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
