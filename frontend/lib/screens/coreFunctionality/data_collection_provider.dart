import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final StateProvider<incorrectCoordinates> incorrectCoordinatesDataProvider =
    StateProvider((ref) => incorrectCoordinates());

class incorrectCoordinates extends StateNotifier<List<List<List<double>>>> {
  incorrectCoordinates() : super([]);

  void addItem(List<List<double>> item) {
    state = [...state, item];
  }

  void removeItem(List<List<double>> item) {
    state = [...state]..remove(item);
  }

  void removeLastItem() {
    if (state.isNotEmpty) {
      state = List.from(state)..removeLast();
    }
  }

  void clearItems() {
    state = [];
  }

  int get length => state.length;
}

final StateProvider<coordinatesData> coordinatesDataProvider =
    StateProvider((ref) => coordinatesData());

class coordinatesData extends StateNotifier<List<List<List<double>>>> {
  coordinatesData() : super([]);

  void addItem(List<List<double>> item) {
    state = [...state, item];
  }

  void removeItem(List<List<double>> item) {
    state = [...state]..remove(item);
  }

  void removeLastItem() {
    if (state.isNotEmpty) {
      state = List.from(state)..removeLast();
    }
  }

  void clearItems() {
    state = [];
  }

  int get length => state.length;
}

final StateProvider<bool> isCollectingCorrect = StateProvider((ref) => true);
final StateProvider<double> averageFrameState = StateProvider((ref) => 0.0);
final StateProvider<int> maxFrameState = StateProvider((ref) => 0);
final StateProvider<int> minFrameState = StateProvider((ref) => 0);
final StateProvider<int> numExec = StateProvider((ref) => 0);
final StateProvider<int> execTotalFrames = StateProvider((ref) => 0);
final StateProvider<int> numExecNegative = StateProvider((ref) => 0);

final StateProvider<String> correctDataSetPath = StateProvider((ref) => "");
final StateProvider<String> incorrectDataSetPath = StateProvider((ref) => "");

final positiveDatasetProvider = StateProvider<File?>((ref) => null);
final negativeDatasetProvider = StateProvider<File?>((ref) => null);

final StateProvider<double> averageFrameNegativeState =
    StateProvider((ref) => 0.0);
final StateProvider<int> maxFrameNegativeState = StateProvider((ref) => 0);
final StateProvider<int> minFrameNegativeState = StateProvider((ref) => 0);

final StateProvider<String> positivedatasetNum = StateProvider((ref) => '');
final StateProvider<String> negativeDatasetNum = StateProvider((ref) => '');

final StateProvider<String> imageUrl = StateProvider((ref) => '');
final StateProvider<String> videoURLProvider = StateProvider((ref) => '');

final imageProvider = StateProvider<File?>((ref) => null);
final StateProvider<Uint8List?> thumbnailProvider =
    StateProvider((ref) => null);
final StateProvider<String> exerciseNameProvider = StateProvider((ref) => '');
final StateProvider<String> exerciseIDProvider = StateProvider((ref) => '');
final StateProvider<String> repsProvider = StateProvider((ref) => '');
final StateProvider<String> setsProvider = StateProvider((ref) => '');
final StateProvider<String> exerciseDescription = StateProvider((ref) => '');
final StateProvider<String> exerciseIntensity = StateProvider((ref) => 'Easy');

final StateProvider<List<String>> exercisePart = StateProvider((ref) => []);

final StateProvider<String> metProvider = StateProvider((ref) => '');
final StateProvider<String> estimatedTimeProvider = StateProvider((ref) => '');
final StateProvider<File?> videoPathProvider = StateProvider((ref) => null);
final StateProvider<Uint8List?> videoThumbnailProvider =
    StateProvider((ref) => null);

final StateProvider<int> recording = StateProvider((ref) => 0);

final StateProvider<bool> showPreviewProvider = StateProvider((ref) => true);
