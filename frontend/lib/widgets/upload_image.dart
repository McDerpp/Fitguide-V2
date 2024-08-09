import 'package:flutter/material.dart';
import 'package:frontend/screens/workout/workout_data_management.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadImage extends ConsumerStatefulWidget {
  final bool isEdit;

  const UploadImage({
    super.key,
    this.isEdit = false,
  });

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends ConsumerState<UploadImage> {
  File? _image;
  Uint8List? _thumbnail;

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      ref.read(imageProvider.notifier).state = file;
      // final test? image = ref.read(imageProvider);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      child: ref.read(imageProvider.notifier).state != null ||
              widget.isEdit == false
          ? InkWell(
              onTap: () async {
                final image = await pickImage();
                // image = ref.read(imageProvider);
                if (image != null) {
                  final thumbnail = await generateThumbnail(image.path);
                  ref.read(imageProvider.notifier).state = image;
                  ref.read(thumbnailProvider.notifier).state = thumbnail;

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

                  setState(() {});
                }
              },
              child: Image.network(ref.read(imageUrl)),
            ),
    );
  }
}


