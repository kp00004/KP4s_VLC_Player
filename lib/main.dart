import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';

void main() => runApp(KPapp());

class KPapp extends StatelessWidget {
  //statelessWidget = changesless parts of the screen
  @override
  Widget build(BuildContext context) {
    //Widget build(BuildContext context)=> common way to use render UI
    return MaterialApp(
      //MaterialApp(controls the flow ig) => home(mainsceen) =>scffold (has many usful things like app bar)
      home: VideoPlayArea(),
    );
  }
}

class VideoPlayArea extends StatefulWidget {
  //statefulwidget = dynamic part of the screen which changes
  //Videoplayarea = the middle area
  @override
  obj createState() => obj(); //like creating an object
}

class obj extends State<VideoPlayArea> {
  //like creating method

  VideoPlayerController? controller; //function from module = varaible
  double videospeed = 1.0; // Default speed

  Future<void> AskVideoFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      //null error
      controller?.dispose();
      controller = VideoPlayerController.network(
          result.files.single.path!) //mount the video to the variable
        ..initialize().then((_) {
          setState(() {});
          controller!.play();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KP4's Video Player")),
      body: Column(
        children: [
          Expanded(
            child: controller == null || !controller!.value.isInitialized
                ? Center(child: Text("Select a video"))
                : AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.folder), onPressed: AskVideoFile),
              IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => controller?.play()),
              IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () => controller?.pause()),
              IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    controller?.pause();
                    controller?.seekTo(Duration.zero);
                  }),
              DropdownButton<double>(
                  value: videospeed,
                  items: [0.5, 1.0, 1.5, 2.0]
                      .map((speed) => DropdownMenuItem(
                            value: speed,
                            child: Text("${speed}x"),
                          ))
                      .toList(),
                  onChanged: (speed) {
                    if (speed != null) {
                      setState(() {
                        videospeed = speed;
                        controller?.setPlaybackSpeed(speed);
                      });
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

