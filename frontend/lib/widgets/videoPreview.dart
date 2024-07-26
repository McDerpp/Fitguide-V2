// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/screens/dataCollection/p4_exerciseDetail.dart';

// import 'package:video_player/video_player.dart';

// import '../../../provider/data_collection_provider.dart';
// import '../../../provider/global_variable_provider.dart';
// import 'custom_button.dart';

// class VideoPreviewScreen extends ConsumerStatefulWidget {
//   final dynamic videoPath;
//   final bool isInferencingPreview;

//   VideoPreviewScreen({
//     required this.videoPath,
//     this.isInferencingPreview = false,
//   });

//   @override
//   _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
// }

// class _VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     // _controller = widget.isInferencingPreview == true
//     //     ? VideoPlayerController.asset(widget.videoPath)
//     //     : VideoPlayerController.file(File(widget.videoPath));
//     // _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//     //   setState(() {});
//     // });
//     _controller = VideoPlayerController.file(
//       widget.videoPath is File ? widget.videoPath : File(widget.videoPath),
//     );

//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map<String, double> textSizeModif = ref.watch(textSizeModifier);

//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     var textSizeModifierSet = ref.watch(textSizeModifier);
//     var textSizeModifierSetIndividual = textSizeModifierSet["smallText"]!;
//     late Map<String, Color> colorSet;

//     Color mainColor = mainColorState;
//     Color secondaryColor = secondaryColorState;
//     Color tertiaryColor = tertiaryColorState;
//     textSizeModifierSet = ref.watch(textSizeModifier);
//     textSizeModifierSetIndividual = textSizeModifierSet["smallText"]!;
//     colorSet = {
//       "mainColor": mainColor,
//       "secondaryColor": secondaryColor,
//       "tertiaryColor": tertiaryColor,
//     };

//     _controller.setLooping(true);
//     _controller.play();

//     return Center(
//       child: Container(
//         width: _controller.value.size.width,
//         height: _controller.value.size.height,
//         child: AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: Stack(
//             children: [
//               VideoPlayer(_controller),
//               widget.isInferencingPreview == false
//                   ? Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         height: screenHeight * 0.11,
//                         width: screenWidth,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(screenHeight * .02),
//                             topRight: Radius.circular(screenHeight * .02),
//                           ),
//                           color: mainColor,
//                         ),
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: screenHeight * 0.01,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 buildElevatedButton(
//                                   context: context,
//                                   label: "Delete",
//                                   colorSet: colorSet,
//                                   textSizeModifierIndividual:
//                                       textSizeModif['smallText2']!,
//                                   func: () {
//                                     ref.watch(vidPath.notifier).state = "";
//                                   },
//                                 ),
//                                 buildElevatedButton(
//                                   context: context,
//                                   label: widget.isInferencingPreview == false
//                                       ? "Submit"
//                                       : "Close",
//                                   colorSet: colorSet,
//                                   textSizeModifierIndividual:
//                                       textSizeModif['smallText2']!,
//                                   func: () {
//                                     ref.watch(vidPath.notifier).state =
//                                         widget.videoPath;
//                                     widget.isInferencingPreview == false
//                                         ? Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const collectionDataP3(),
//                                             ),
//                                           )
//                                         : ref
//                                             .watch(showPreviewProvider.notifier)
//                                             .state = false;
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
