import 'package:flutter/material.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoThumbnailScreen extends ConsumerStatefulWidget {
  final String imageUrl;
  final bool isEdit;

  const VideoThumbnailScreen({
    super.key,
    this.imageUrl = "",
    this.isEdit = false,
  });

  @override
  _VideoThumbnailScreenState createState() => _VideoThumbnailScreenState();
}

class _VideoThumbnailScreenState extends ConsumerState<VideoThumbnailScreen> {
  File? _image;
  Uint8List? _thumbnail;

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      ref.read(imageProvider.notifier).state = file;
      // final test? image = ref.read(imageProvider);
      print('Selected image path: ${ref.read(imageProvider)}');
      return file;
    }
    return null;
  }

  Future<Uint8List?> generateThumbnail(String imagePath) async {
    final Uint8List? uint8list = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 150,
      minHeight: 150,
      quality: 100,
    );
    return uint8list;
  }

  void printImagePath() {
    final File? image = ref.read(imageProvider);
    if (image != null) {
      print('Selected image path: ${image.path}');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: widget.isEdit == false
          ? InkWell(
              onTap: () async {
                final image = await pickImage();
                // image = ref.read(imageProvider);
                if (image != null) {
                  final thumbnail = await generateThumbnail(image.path);
                  ref.read(imageProvider.notifier).state = image;
                  ref.read(thumbnailProvider.notifier).state = thumbnail;
                  printImagePath();

                  setState(() {});
                }
              },
              child: ref.read(thumbnailProvider) == null
                  ? Container(
                      height: 150,
                      width: 150,
                      color: Colors.grey[300],
                      child: Center(child: Text('Tap to pick image')),
                    )
                  : Image.memory(ref.read(thumbnailProvider.notifier).state!),
            )
          : GestureDetector(
              onTap: () async {
                final image = await pickImage();
                // image = ref.read(imageProvider);
                if (image != null) {
                  final thumbnail = await generateThumbnail(image.path);
                  ref.read(imageProvider.notifier).state = image;
                  ref.read(thumbnailProvider.notifier).state = thumbnail;
                  printImagePath();

                  setState(() {});
                }
              },
              child: Image.network(
                widget.imageUrl,
              ),
            ),
    );
  }
}




// class VideoThumbnailScreen extends StatefulWidget {
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

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter_image_compress/flutter_image_compress.dart';


// class VideoThumbnailScreen extends StatefulWidget {
//   @override
//   _VideoThumbnailScreenState createState() => _VideoThumbnailScreenState();
// }

// class _VideoThumbnailScreenState extends State<VideoThumbnailScreen> {
//   File? _image;
//   Uint8List? _thumbnail;

//   Future<File?> pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       return File(image.path);
//     }
//     return null;
//   }

//   Future<Uint8List?> generateThumbnail(String imagePath) async {
//     final Uint8List? uint8list = await FlutterImageCompress.compressWithFile(
//       imagePath,
//       minWidth: 150,
//       minHeight: 150,
//       quality: 50,
//     );
//     return uint8list;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _thumbnail == null
//                 ? Text('No image selected.')
//                 : Image.memory(_thumbnail!),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final image = await pickImage();
//                 if (image != null) {
//                   final thumbnail = await generateThumbnail(image.path);
//                   setState(() {
//                     _image = image;
//                     _thumbnail = thumbnail;
//                   });
//                 }
//               },
//               child: Text('Pick Image'),
//             ),
//           ],
//         );
//   }
// }

