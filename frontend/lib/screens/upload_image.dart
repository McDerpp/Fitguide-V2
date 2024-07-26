// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:io';
// import 'dart:typed_data';


// class VideoThumbnailScreen extends StatefulWidget {
//   const VideoThumbnailScreen({super.key});

//   @override
//   _VideoThumbnailScreenState createState() => _VideoThumbnailScreenState();
// }

// class _VideoThumbnailScreenState extends State<VideoThumbnailScreen> {
//   File? _video;
//   Uint8List? _thumbnail;



// Future<File?> pickVideo() async {
//   final ImagePicker _picker = ImagePicker();
//   final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

//   if (video != null) {
//     return File(video.path);
//   }
//   return null;
// }

// Future<Uint8List?> generateThumbnail(String videoPath) async {
//   final uint8list = await VideoThumbnail.thumbnailData(
//     video: videoPath,
//     imageFormat: ImageFormat.JPEG,
//     maxHeight: 64, // specify the height of the thumbnail, width is auto-scaled
//     quality: 75,
//   );
//   return uint8list;
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pick Video and Show Thumbnail'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _thumbnail == null
//                 ? Text('No video selected.')
//                 : Image.memory(_thumbnail!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final video = await pickVideo();
//                 if (video != null) {
//                   final thumbnail = await generateThumbnail(video.path);
//                   setState(() {
//                     _video = video;
//                     _thumbnail = thumbnail;
//                   });
//                 }
//               },
//               child: Text('Pick Video'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
