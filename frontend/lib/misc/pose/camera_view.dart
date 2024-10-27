
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/coreFunctionality/pose_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/data_collection_settings.dart';

import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class CameraView extends ConsumerStatefulWidget {
  bool isCollecting;
  CameraView(
      {super.key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.front,
      this.onControllerInitialized,
      this.isCollecting = false});

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final Function(CameraController)? onControllerInitialized;

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  VoidCallback? videoPlayerListener;
  int _cameraIndex = -1;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  final double _currentScale = 1.0;
  final double _baseScale = 1.0;
  double _currentExposureOffset = 0.0;
  // bool _changingCameraLens = false;

  XFile? imageFile;
  XFile? videoFile;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

// // ====================================================================================

  void checkingRecordState() {}

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _liveFeedBody();
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return Container();
    }
    final scale = 1 /
        (_controller!.value.aspectRatio *
            MediaQuery.of(context).size.aspectRatio);

    return widget.isCollecting == false
        // if inferencing this will run
        ? Transform.scale(
            scaleX: scale * scaleX,
            scaleY: scale * scaleY,
            alignment: Alignment.center,
            // this is for inferencing showing video reference
            child: ref.watch(showPreviewProvider) == true
                ? Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: widget.customPaint,
                      )
                    ],
                  )
                // this is for inferencing
                : CameraPreview(
                    _controller!,
                    child: widget.customPaint ?? const Text(""),
                  ),
          )
        // this is for data collection
        : Transform.scale(
            scaleX: scale * 0.95,
            scaleY: scale * 0.80,
            alignment: Alignment.center,
            child: CameraPreview(
              _controller!,
              child: widget.customPaint ?? const Text(""),
            ),
          );
  }

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    widget.onControllerInitialized!(_controller!);

    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });
      _currentExposureOffset = 0.0;
      _controller?.getMinExposureOffset().then((value) {
        _minAvailableExposureOffset = value;
      });
      _controller?.getMaxExposureOffset().then((value) {
        _maxAvailableExposureOffset = value;
      });
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    print("camera disposed!");
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  double _calculateAverageLuminance(CameraImage image) {
    const int plane = 0; // Y plane

    final Uint8List bytes = image.planes[plane].bytes;

    double results = 0;
    int bytesLength = bytes.length ~/ 2;

    for (int i = 0; i < bytesLength / 2; i++) {
      if (i % 2 == 0) {
        results += bytes[i];
      }
    }
    results = results / bytes.length;
    return results;
  }

  void _processCameraImage(CameraImage image) {
    ref.read(luminanceProvider.notifier).state =
        _calculateAverageLuminance(image);

    final CameraController? cameraController = _controller;

    // int recordings = ref.watch(recording);

    if (cameraController!.value.isInitialized == true) {
    } else {}

    if (!cameraController.value.isRecordingVideo == true) {
    } else {}

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
