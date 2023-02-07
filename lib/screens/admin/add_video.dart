import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
import 'package:psychiatric_asylums/screens/admin/admin_bottom.dart';

import 'admin_home.dart';

class AddVideo extends StatefulWidget {
  static const routeName = '/addVideo';
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  var titleController = TextEditingController();
  File? file;
  var videoUrl = '';

  Future selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path!);
    });
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('videos');
    Reference refrenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await refrenceImageToUpload.putFile(File(path!));

      videoUrl = await refrenceImageToUpload.getDownloadURL();
    } catch (error) {}
    print(videoUrl);
  }

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
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: HexColor('#f2f0f7'),
                              backgroundImage: null,
                            )),
                        Positioned(
                            top: 120,
                            left: 120,
                            child: SizedBox(
                              width: 50,
                              child: RawMaterialButton(
                                  // constraints: BoxConstraints.tight(const Size(45, 45)),
                                  elevation: 10,
                                  fillColor: HexColor('#b4a7d6'),
                                  child: const Align(
                                      // ignore: unnecessary_const
                                      child: Icon(Icons.add_a_photo,
                                          color: Colors.white, size: 22)),
                                  padding: const EdgeInsets.all(15),
                                  shape: const CircleBorder(),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Choose option',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        HexColor('#b4a7d6'))),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        selectFile();
                                                      },
                                                      splashColor:
                                                          HexColor('#b4a7d6'),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                                Icons.image,
                                                                color: HexColor(
                                                                    '#b4a7d6')),
                                                          ),
                                                          Text('Gallery',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ))
                                                        ],
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        //pickImageFromCamera();
                                                      },
                                                      splashColor:
                                                          HexColor('#FA8072'),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                                Icons.camera,
                                                                color: HexColor(
                                                                    '#b4a7d6')),
                                                          ),
                                                          Text('Camera',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ))
                                                        ],
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      splashColor:
                                                          HexColor('#FA8072'),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Icon(
                                                                Icons
                                                                    .remove_circle,
                                                                color: HexColor(
                                                                    '#b4a7d6')),
                                                          ),
                                                          Text('Remove',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ))
                                                        ],
                                                      ))
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    height: 65.h,
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        fillColor: HexColor('#155564'),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor('#b4a7d6'), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'عنوان الفيديو',
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
                        String title = titleController.text.trim();

                        if (title.isEmpty) {
                          Fluttertoast.showToast(msg: 'ادخل عنوان الفيديو');
                          return;
                        }

                        if (videoUrl.isEmpty) {
                          Fluttertoast.showToast(msg: 'برجاء الانتظار حتى يتم رفع الفيديو');
                          return;
                        }

                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          String uid = user.uid;
                          int date = DateTime.now().millisecondsSinceEpoch;

                          DatabaseReference companyRef = FirebaseDatabase
                              .instance
                              .reference()
                              .child('videos');

                          String? id = companyRef.push().key;

                          await companyRef.child(id!).set({
                            'id': id,
                            'videoUrl': videoUrl,
                            'title': title,
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
      Navigator.pushNamed(context, BottomBarScreen.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("تم أضافة الفيديو"),
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
