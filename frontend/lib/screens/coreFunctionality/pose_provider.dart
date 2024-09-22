import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/inferencing/inferencing/mainUISettings.dart';

final StateProvider<bool> isPerforming = StateProvider((ref) => false);
final StateProvider<double> luminanceProvider = StateProvider((ref) => 0.0);

final StateProvider<List<int>> ignoreCoordinatesProvider =
    StateProvider((ref) => [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          12,
          11,
          24,
          23,
          11,
          13,
          21,
          17,
          19,
          15,
          12,
          14,
          16,
          18,
          20,
          22,
          23,
          25,
          27,
          29,
          31,
          24,
          26,
          28,
          32,
          30
        ]);

final StateProvider<bool> isAllCoordinatesPresent =
    StateProvider((ref) => false);

final StateProvider<bool> headBoolState = StateProvider((ref) => true);
final StateProvider<bool> leftArmBoolState = StateProvider((ref) => true);
final StateProvider<bool> rightArmBoolState = StateProvider((ref) => true);
final StateProvider<bool> leftLegBoolState = StateProvider((ref) => true);
final StateProvider<bool> rightLegBoolState = StateProvider((ref) => true);
final StateProvider<bool> bodyBoolState = StateProvider((ref) => true);

final StateProvider<List<bool>> ignoreCoordinateslistProvider =
    StateProvider((ref) => [
          ref.watch(headBoolState),
          ref.watch(leftArmBoolState),
          ref.watch(rightArmBoolState),
          ref.watch(leftLegBoolState),
          ref.watch(rightLegBoolState),
          ref.watch(bodyBoolState),
        ]);

final StateProvider<Map<String, dynamic>> headColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);
final StateProvider<Map<String, dynamic>> leftArmColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);
final StateProvider<Map<String, dynamic>> rightArmColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);
final StateProvider<Map<String, dynamic>> leftLegColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);
final StateProvider<Map<String, dynamic>> rightLegColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);
final StateProvider<Map<String, dynamic>> bodyColor =
    StateProvider((ref) => ref.watch(ColorSet)["ColorSet1"]!);

final StateProvider<List<int>> head =
    StateProvider((ref) => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
final StateProvider<List<int>> body = StateProvider((ref) => []);
final StateProvider<List<int>> leftArm =
    StateProvider((ref) => [11, 13, 25, 21, 17, 19]);
final StateProvider<List<int>> rightArm =
    StateProvider((ref) => [12, 14, 16, 18, 20, 22]);
final StateProvider<List<int>> leftLeg =
    StateProvider((ref) => [23, 25, 27, 29, 31]);
final StateProvider<List<int>> rightLeg =
    StateProvider((ref) => [24, 26, 28, 32, 30]);
