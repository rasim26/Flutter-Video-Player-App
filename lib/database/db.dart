import 'package:hive_flutter/hive_flutter.dart';

class VideoDatabase {
  static const _galleryBox = 'Gallery';
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(
        _galleryBox); // ensure the box is opened for use.
  }
  // _galleryBox is used for storing.
  static Future<void> addVideo(String videoPath) async {
    //print('function started');

    var box = await Hive.openBox<String>(_galleryBox);
    //print('box opened');
    await box.add(videoPath);
    //print('video added');
    //final data = box.values;
    //print(data);
  }

  //List videos
  static Future<List<String>> getVideos() async {
    var box = await Hive.openBox<String>(_galleryBox);
    final List<String> videoList = box.values.toList();
    // here we uses the toList() for converting to the List from String.
    return videoList;
  }

  // Delete part
  static Future<void> deleteVideo(String videoPath) async {
    var box = await Hive.openBox<String>(_galleryBox);

    final List<String> videoList = box.values.toList();
    videoList.removeWhere((element) => element == videoPath);
    // removeWhere is used to delete a specific video.

    await box.clear();
    await box.addAll(videoList); 
    // here we use removewhere first and then clear
    // the box, then add all from the videoList.
  }
}
