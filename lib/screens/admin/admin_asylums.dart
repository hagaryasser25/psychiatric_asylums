import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/add_asylum.dart';
import 'package:psychiatric_asylums/screens/models/asylums_model.dart';

class AdminAsylums extends StatefulWidget {
  static const routeName = '/adminAsylums';
  const AdminAsylums({super.key});

  @override
  State<AdminAsylums> createState() => _AdminAsylumsState();
}

class _AdminAsylumsState extends State<AdminAsylums> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Asylums> asylumsList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchAsylums();
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
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 40.h, left: 10.w),
            child: FloatingActionButton(
              backgroundColor: HexColor('#b4a7d6'),
              onPressed: () {
                Navigator.pushNamed(context, AddAsylum.routeName);
              },
              child: Icon(Icons.add),
            ),
          ),
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
                              padding: const EdgeInsets.only(
                                  top: 10,  bottom: 10),
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
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) =>
                                                            super.widget));
                                            base
                                                .child(asylumsList[index]
                                                    .id
                                                    .toString())
                                                .remove();
                                          },
                                          child: Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 122, 122, 122)),
                                        )
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
