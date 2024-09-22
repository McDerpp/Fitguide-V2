// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/screens/coreFunctionality/globalVariables.dart';
// import 'package:frontend/screens/coreFunctionality/provider_collection.dart';

// void initiateIgnoreCoordinates(WidgetRef ref) {
//   List<int> head = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   List<int> body = [12, 11, 24, 23];
//   List<int> leftArm = [11, 13, 21, 17, 19, 15];
//   List<int> rightArm = [12, 14, 16, 18, 20, 22];
//   List<int> leftLeg = [23, 25, 27, 29, 31];
//   List<int> rightLeg = [24, 26, 28, 32, 30];
//   ref.read(ignoreCoordinatesProvider).clear();

//   if (ref.watch(headBoolState) == true) {
//     for (int coordinate in head) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }

//   if (ref.watch(bodyBoolState) == true) {
//     // ignoreCoordinatesInitialized.addAll(body);
//     for (int coordinate in body) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }

//   if (ref.watch(leftArmBoolState) == true) {
//     // ignoreCoordinatesInitialized.addAll(leftArm);
//     for (int coordinate in leftArm) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }

//   if (ref.watch(rightArmBoolState) == true) {
//     // ignoreCoordinatesInitialized.addAll(rightArm);
//     for (int coordinate in rightArm) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }

//   if (ref.watch(leftLegBoolState) == true) {
//     // ignoreCoordinatesInitialized.addAll(leftLeg);
//     for (int coordinate in leftLeg) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }

//   if (ref.watch(rightLegBoolState) == true) {
//     // ignoreCoordinatesInitialized.addAll(rightLeg);
//     for (int coordinate in rightLeg) {
//       ref.read(ignoreCoordinatesProvider).add(coordinate);
//     }
//   }
// }
