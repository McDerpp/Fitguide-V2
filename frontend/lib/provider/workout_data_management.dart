import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> workout = StateProvider((ref) => 0);

final StateProvider<List<int>> baseExerciseListProvider =
    StateProvider((ref) => []);

final StateProvider<List<int>> exerciseListProvider =
    StateProvider((ref) => []);

final StateProvider<bool> initExerciseEdit = StateProvider((ref) => false);

final StateProvider<String> name = StateProvider((ref) => '');
final StateProvider<String> id = StateProvider((ref) => '');
final StateProvider<String> difficulty = StateProvider((ref) => '');
final StateProvider<String> workoutID = StateProvider((ref) => '');
final StateProvider<String> accountID = StateProvider((ref) => '');

final StateProvider<String> user = StateProvider((ref) => '');
final StateProvider<String> intensity = StateProvider((ref) => 'Easy');
final StateProvider<String> type = StateProvider((ref) => 'Cardio');

final StateProvider<String> description = StateProvider((ref) => '');
final StateProvider<String> imageUrl = StateProvider((ref) => '');

final StateProvider<File?> image = StateProvider((ref) => null);
final imageProvider = StateProvider<File?>((ref) => null);
final StateProvider<Uint8List?> thumbnailProvider =
    StateProvider((ref) => null);






