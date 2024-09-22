import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> initExerciseEdit = StateProvider((ref) => false);

final StateProvider<String> exerciseNameProvider = StateProvider((ref) => '');
final StateProvider<String> exerciseIDProvider = StateProvider((ref) => '');
final StateProvider<String> repsProvider = StateProvider((ref) => '');
final StateProvider<String> setsProvider = StateProvider((ref) => '');
final StateProvider<String> exerciseDescription = StateProvider((ref) => '');
final StateProvider<String> exerciseIntensity = StateProvider((ref) => 'Easy');
final StateProvider<String> exercisePart = StateProvider((ref) => 'Neck');
final StateProvider<String> metProvider = StateProvider((ref) => '');
final StateProvider<String> estimatedTimeProvider = StateProvider((ref) => '');

final StateProvider<String> videoURLProvider = StateProvider((ref) => '');
final StateProvider<File?> videoPathProvider = StateProvider((ref) => null);
final videoProvider = StateProvider<File?>((ref) => null);
final StateProvider<Uint8List?> videoThumbnailProvider =
    StateProvider((ref) => null);

final positiveDatasetProvider = StateProvider<File?>((ref) => null);
final negativeDatasetProvider = StateProvider<File?>((ref) => null);

final StateProvider<String> positivedatasetNum = StateProvider((ref) => '');
final StateProvider<String> negativeDatasetNum = StateProvider((ref) => '');




// ref.watch(isCollectingCorrect.notifier).state == true