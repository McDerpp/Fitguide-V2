// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// final StateProvider<bool> isPerforming = StateProvider((ref) => false);
// final StateProvider<bool> isAllCoordinatesPresent =
//     StateProvider((ref) => false);
// final StateProvider<bool> isCollectingCorrect = StateProvider((ref) => true);
// final StateProvider<int> numExec = StateProvider((ref) => 0);
// final StateProvider<int> numExecNegative = StateProvider((ref) => 0);
// final StateProvider<double> luminanceProvider = StateProvider((ref) => 0.0);



// // ===============================================================================
// final StateProvider<coordinatesData> coordinatesDataProvider =
//     StateProvider((ref) => coordinatesData());

// class coordinatesData extends StateNotifier<List<List<List<double>>>> {
//   coordinatesData() : super([]);

//   void addItem(List<List<double>> item) {
//     state = [...state, item];
//   }

//   void removeItem(List<List<double>> item) {
//     state = [...state]..remove(item);
//   }

//   void removeLastItem() {
//     if (state.isNotEmpty) {
//       state = List.from(state)..removeLast();
//     }
//   }

//   void clearItems() {
//     state = [];
//   }
// }
// // ===============================================================================

// // ===============================================================================

// final StateProvider<incorrectCoordinates> incorrectCoordinatesDataProvider =
//     StateProvider((ref) => incorrectCoordinates());

// class incorrectCoordinates extends StateNotifier<List<List<List<double>>>> {
//   incorrectCoordinates() : super([]);

//   void addItem(List<List<double>> item) {
//     state = [...state, item];
//   }

//   void removeItem(List<List<double>> item) {
//     state = [...state]..remove(item);
//   }

//   void removeLastItem() {
//     if (state.isNotEmpty) {
//       state = List.from(state)..removeLast();
//     }
//   }

//   void clearItems() {
//     state = [];
//   }
// }
// // ===============================================================================
