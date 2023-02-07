import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:psychiatric_asylums/screens/admin/add_video.dart';
import 'package:psychiatric_asylums/screens/admin/fetch_videos.dart';
import 'package:psychiatric_asylums/screens/models/videos_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:video_player/video_player.dart';

class AdminVideos extends StatefulWidget {
  static const routeName = '/adminVideos';
  const AdminVideos({super.key});

  @override
  State<AdminVideos> createState() => _AdminVideosState();
}

class _AdminVideosState extends State<AdminVideos> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<VideosV> videosList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchVideos();
  }

  @override
  void fetchVideos() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("videos");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      VideosV p = VideosV.fromJson(event.snapshot.value);
      videosList.add(p);
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
                  child: Text('فيديوهات توعية'),
                ))),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 40.h, left: 10.w),
              child: FloatingActionButton(
                backgroundColor: HexColor('#b4a7d6'),
                onPressed: () {
                  Navigator.pushNamed(context, AddVideo.routeName);
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
                        itemCount: videosList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return FetchVideos(
                                    url: '${videosList[index].videoUrl}',
                                  );
                                }));
                              },
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.w, left: 10.w),
                                  child: Center(
                                    child: Column(children: [
                                      SizedBox(
                                        height: 100.h,
                                      ),
                                      Text(
                                        '${videosList[index].title}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: HexColor('#b4a7d6')),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          super.widget));
                                          base..child(videosList[index]
                                                    .id
                                                    .toString())
                                                .remove();
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
                        mainAxisSpacing: 35.0,
                        crossAxisSpacing: 5.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
