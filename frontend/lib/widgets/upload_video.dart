// import 'package:flutter/material.dart';
// import 'package:frontend/screens/exercise/exercise_data_management.dart';
// import 'package:frontend/provider/workout_data_management.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UploadVideo extends ConsumerStatefulWidget {
//   final bool isEdit;

//   const UploadVideo({
//     super.key,
//     this.isEdit = false,
//   });

//   @override
//   _UploadVideoState createState() => _UploadVideoState();
// }

// class _UploadVideoState extends ConsumerState<UploadVideo> {
//   File? _video;
//   Uint8List? _thumbnail;

//   Future<File?> pickVideo() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

//     if (video != null) {
//       final file = File(video.path);
//       ref.read(videoPathProvider.notifier).state = file;
//       return file;
//     }
//     return null;
//   }

//   Future<Uint8List?> generateThumbnail(String videoPath) async {
//     final uint8list = await VideoThumbnail.thumbnailData(
//       video: videoPath,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight: 150,
//       maxWidth: 150,
//       quality: 100,
//     );
//     return uint8list;
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   void initEdit() {}

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: MediaQuery.of(context).size.height * .25,
//         width: MediaQuery.of(context).size.width * .9,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: ref.read(videoPathProvider.notifier).state != null ||
//                   widget.isEdit == false
//               ? InkWell(
//                   onTap: () async {
//                     final video = await pickVideo();
//                     if (video != null) {
//                       final thumbnail = await generateThumbnail(video.path);
//                       ref.read(videoPathProvider.notifier).state = video;
//                       ref.read(videoThumbnailProvider.notifier).state =
//                           thumbnail;

//                       setState(() {});
//                     }
//                   },
//                   child: ref.read(videoThumbnailProvider) == null
//                       ? Container(
//                           height: 150,
//                           width: 150,
//                           color: Colors.grey[300],
//                           child: Center(child: Icon(Icons.video_camera_front)),
//                         )
//                       : Image.memory(
//                           ref.read(videoThumbnailProvider.notifier).state!),
//                 )
//               : GestureDetector(
//                   onTap: () async {
//                     final video = await pickVideo();
//                     if (video != null) {
//                       final thumbnail = await generateThumbnail(video.path);
//                       ref.read(videoPathProvider.notifier).state = video;
//                       ref.read(videoThumbnailProvider.notifier).state =
//                           thumbnail;

//                       setState(() {});
//                     }
//                   },
//                   child: Image.memory(ref.read(videoThumbnailProvider)!),
//                 ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/screens/exercise/exercise_data_management.dart';
import 'package:frontend/provider/workout_data_management.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadVideo extends ConsumerStatefulWidget {
  final Uint8List? thumbnail;

  final void Function(File?) onChangeVideo;
  final void Function(Uint8List?) onChangeVideoThumbnail;

  const UploadVideo({
    super.key,
    required this.onChangeVideo,
    required this.onChangeVideoThumbnail,
    required this.thumbnail,
  });

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends ConsumerState<UploadVideo> {
  Future<File?> pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      final file = File(video.path);

      return file;
    }
    return null;
  }

  Future<Uint8List?> generateThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 150,
      maxWidth: 150,
      quality: 100,
    );
    return uint8list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void initEdit() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width * .9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () async {
            final video = await pickVideo();
            if (video != null) {
              widget
                  .onChangeVideoThumbnail(await generateThumbnail(video.path));
              widget.onChangeVideo(video);
            }
          },
          child: widget.thumbnail == null
              ? Container(
                  height: 800,
                  width: 800,
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.video_camera_front)),
                )
              : Image.memory(widget.thumbnail!),
        ),
      ),
    );
  }
}
