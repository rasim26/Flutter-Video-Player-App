import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_video_player_with_hive/database/db.dart';
import 'package:local_video_player_with_hive/screens/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _select = ImagePicker();
  List<String> videoPaths = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    videoPaths = await VideoDatabase.getVideos();
    //here, we can rebuild and show the videos after adding.
    setState(() {});
  }

  // Pick Videos.
  Future _selectVideos() async {
    final XFile? video = await _select.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      await _saveVideo(video.path);
      _loadVideos();
    }
  }

  // Record Video.
  Future<void> _recordVideo() async {
    final XFile? video = await _select.pickVideo(source: ImageSource.camera);
    if (video != null) {
      await _saveVideo(video.path);
      _loadVideos();
    }
  }

  // To Save Videos.
  Future _saveVideo(String path) async {
    if (!videoPaths.contains(path)) {
      videoPaths.add(path);
      await VideoDatabase.addVideo(path);
      setState(() {
        videoPaths;
      });
    }
  }

  void _deleteVideo(String videoPath) async {
    await VideoDatabase.deleteVideo(videoPath);
    setState(() {
      _loadVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    //Basic UI.
    return Scaffold(
      backgroundColor:
          Image.asset('lib/Assets/Image/pexels-bertellifotografia-799443.jpg')
              .color,
      appBar: AppBar(
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Click the camera icon'),
        //   ),
        //  ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(17),
            bottomRight: Radius.circular(17),
          ),
        ),
        shadowColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Local Video Player',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // To List Videos.
      body: ListView.builder(
        itemCount: videoPaths.length,
        itemBuilder: (context, index) {
          // Slide to delete feature implemented on Dissmissible.
          return Dismissible(
            key: Key(videoPaths[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              // Delete Video by Sliding to Left.
              _deleteVideo(videoPaths[index]);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video deleted')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                splashColor: Colors.black87,
                minVerticalPadding: 10,
                contentPadding: EdgeInsets.all(0.5),
                shape: OutlineInputBorder(
                    gapPadding: 5,
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.blueGrey,
                    )),
                title: Text(
                  'Video ${index + 1}',
                  textAlign: TextAlign.center,
                ),
                hoverColor: Colors.red,
                titleTextStyle: const TextStyle(
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                  //backgroundColor: const Color.fromARGB(131, 153, 154, 155),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoPlayerScreen(videoPath: videoPaths[index]),
                    ),
                  );
                  // setState(() {
                  //   _loadVideos();
                  // });
                },
              ),
            ),
          );
        },
      ),
      //floating action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _options(),
        shape: const CircleBorder(),
        hoverColor: Colors.black,
        hoverElevation: 100,
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }

  //options
  void _options() async {
    //ModalBottomSheet for selecting gallery or api camera
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              //tileColor: Colors.blueGrey,
              leading: const Icon(Icons.video_library),
              title: const Text('Select From Gallery'),
              onTap: () {
                Navigator.pop(context);
                _selectVideos();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                _recordVideo();
              },
            ),
          ],
        );
      },
    );
  }
}
