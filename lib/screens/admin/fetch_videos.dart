import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

class FetchVideos extends StatefulWidget {
  String url;
  static const routeName = '/fetchVideos';

  FetchVideos({
    required this.url,
  });

  @override
  State<FetchVideos> createState() => _FetchVideosState();
}

class _FetchVideosState extends State<FetchVideos> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  void initState() {
    _controller = VideoPlayerController.network('${widget.url}');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(HexColor('#b4a7d6')),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('#b4a7d6'),
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
