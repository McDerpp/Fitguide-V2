import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/account.dart';
import 'package:frontend/screens/coreFunctionality/data_collection_provider.dart';
import 'package:frontend/screens/dataCollection/create_exercise/base_collection_v1.dart';
import 'package:frontend/widgets/upload_image.dart';
import 'package:frontend/provider/main_settings.dart';

import 'package:frontend/services/exercise.dart';
import 'package:frontend/widgets/dialog_box.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/input_field.dart';
import 'package:frontend/widgets/navigation_drawer.dart';
import 'package:frontend/widgets/upload_video.dart';

class CreateExercise extends ConsumerStatefulWidget {
  final bool isEdit;

  const CreateExercise({
    super.key,
    this.isEdit = false,
  });

  @override
  ConsumerState<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends ConsumerState<CreateExercise> {
  List<String> _intensity = ['Easy', 'Normal', 'Hard', 'Advance'];
  final List<String> _part = [
    'Neck',
    'Traps',
    'Shoulder',
    'Chest',
    'Biceps',
    'Forearms',
    'Abs',
    'Quadriceps',
    'Calves',
    'Upper Back',
    'Triceps',
    'Lower Back',
    'Glutes',
    'Hamstrings',
    'Others'
  ];

  late String selected_intensity;
  late String selected_part;

  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  final TextEditingController estimateTimeController = TextEditingController();
  final TextEditingController METController = TextEditingController();

  final TextEditingController negativeDatasetController =
      TextEditingController();
  final TextEditingController positiveDatasetController =
      TextEditingController();

  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController descriptionNameController =
      TextEditingController();

  String title = '';
  File? exerciseImage;
  bool isInit = false;

  List<int> pickedExercise = [];
  List<int> toRemoveExercise = [];
  List<int> toAddExercise = [];

  @override
  void initState() {
    super.initState();
    selected_intensity = _intensity[0];
    selected_part = _part[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initExerciseData();
    });
  }

  void navigateAddDataset() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BaseCollection()),
    );
  }

  Widget dropDown(List<String> inputList, String selectedItem,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: selectedItem,
      hint: Text(
        inputList[0],
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      underline: Container(
        // Customize the underline
        height: 0,
        color: Colors.transparent,
      ),
      items: inputList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void initDataset() {
    negativeDatasetController.text =
        ref.watch(coordinatesDataProvider).state.length.toString();
    positiveDatasetController.text =
        ref.watch(incorrectCoordinatesDataProvider).state.length.toString();
  }

  void initExerciseData() {
    setState(() {
      exerciseNameController.text = ref.watch(exerciseNameProvider);
      setsController.text = ref.watch(setsProvider);
      repsController.text = ref.watch(repsProvider);
      selected_intensity = ref.watch(exerciseIntensity);
      selected_part = ref.watch(exercisePart);
      descriptionNameController.text = ref.watch(exerciseDescription);
      METController.text = ref.watch(metProvider);
      estimateTimeController.text = ref.watch(estimatedTimeProvider);

      positiveDatasetController.text = ref.watch(positivedatasetNum);
      negativeDatasetController.text = ref.watch(negativeDatasetNum);
    });
  }

  void saveData() {
    ref.read(setsProvider.notifier).state = setsController.text;
    ref.read(repsProvider.notifier).state = repsController.text;
    ref.read(exerciseIntensity.notifier).state = selected_intensity;
    ref.read(exercisePart.notifier).state = selected_part;
    ref.read(exerciseDescription.notifier).state =
        descriptionNameController.text;
    ref.read(exerciseNameProvider.notifier).state = exerciseNameController.text;
    ref.read(metProvider.notifier).state = METController.text;
    ref.read(estimatedTimeProvider.notifier).state =
        estimateTimeController.text;
  }

  void validateInput() {
    showCustomDialog(
      widthMultiplier: 0.5,
      heightMultiplier: 0.25,
      context,
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Invalid Inputs:",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              exerciseNameController.text == ""
                  ? const Text(
                      "  - Enter a workout name",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                      ),
                    )
                  : const SizedBox(),
              ref.read(imageProvider) == null
                  ? const Text(
                      "  - Select a exercise image",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              ref.read(videoPathProvider) == null
                  ? const Text(
                      "  - Select a exercise video",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              ref.read(positiveDatasetProvider) == null
                  ? const Text(
                      "  - No positive dataset",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              ref.read(negativeDatasetProvider) == null
                  ? const Text(
                      "  - No negative dataset",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              repsController == "" || repsController == "0"
                  ? const Text(
                      "  - No reps specified",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              setsController.text == "" || setsController.text == "0"
                  ? const Text(
                      "  - No sets specified",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 5),
                    foregroundColor: Colors.white,
                    backgroundColor: tertiaryColor,
                  ),
                  child: const Text("Close"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void initExercise() {
    setsController.text = ref.read(setsProvider);
    repsController.text = ref.read(repsProvider);
    exerciseNameController.text = ref.read(exerciseNameProvider);
    descriptionNameController.text = ref.read(exerciseDescription);
    estimateTimeController.text = ref.read(estimatedTimeProvider);
    METController.text = ref.read(metProvider);
    selected_intensity = ref.read(exerciseIntensity);
    selected_part = ref.read(exercisePart);
  }

  Future<void> editData() async {
    if (ref.read(exerciseNameProvider) != "" &&
        ref.read(exerciseIntensity) != "" &&
        ref.read(exerciseDescription) != "" &&
        ref.read(setsProvider) != "" &&
        ref.read(repsProvider) != "" &&
        ref.read(setsProvider) != "0" &&
        ref.read(repsProvider) != "0" &&
        ref.read(estimatedTimeProvider) != "" &&
        ref.read(metProvider) != "" &&
        ref.read(estimatedTimeProvider) != "0" &&
        ref.read(metProvider) != "0" &&
        widget.isEdit == true) {
      await ExerciseApiService.editExercise(
        ref: ref,
        positiveNum: ref.watch(coordinatesDataProvider).state.length.toString(),
        negativeNum:
            ref.watch(incorrectCoordinatesDataProvider).state.length.toString(),
        exerciseID: int.parse(ref.read(exerciseIDProvider)),
        name: exerciseNameController.text,
        intensity: selected_intensity,
        description: ref.read(exerciseDescription),
        sets: ref.read(setsProvider),
        reps: ref.read(repsProvider),
        image: ref.read(imageProvider),
        video: ref.read(videoPathProvider),
        positiveDataset: ref.read(positiveDatasetProvider),
        negativeDataset: ref.read(negativeDatasetProvider),
        estimatedTime: estimateTimeController.text,
        parts: selected_part,
        MET: METController.text,
      );
      print("PASSED!!!!!!!!!");
    }
  }

  void submitData() async {
    if (ref.read(exerciseNameProvider) != "" &&
        ref.read(exerciseIntensity) != "" &&
        ref.read(exerciseDescription) != "" &&
        ref.read(exerciseIntensity) != "" &&
        ref.read(exerciseDescription) != "" &&
        ref.read(setsProvider) != "" &&
        ref.read(repsProvider) != "" &&
        ref.read(setsProvider) != "0" &&
        ref.read(repsProvider) != "0" &&
        ref.read(imageProvider) != null &&
        ref.read(videoPathProvider) != null &&
        ref.read(positiveDatasetProvider) != null &&
        ref.read(negativeDatasetProvider) != null &&
        widget.isEdit == false) {
      await ExerciseApiService.addExercise(
        ref: ref,
        part: ref.read(exercisePart),
        positiveNum: ref.watch(coordinatesDataProvider).state.length.toString(),
        negativeNum:
            ref.watch(incorrectCoordinatesDataProvider).state.length.toString(),
        accountId: int.parse(setup.id),
        name: ref.read(exerciseNameProvider),
        intensity: ref.read(exerciseIntensity),
        description: ref.read(exerciseDescription),
        sets: ref.read(setsProvider),
        reps: ref.read(repsProvider),
        image: ref.read(imageProvider),
        video: ref.read(videoPathProvider),
        positiveDataset: ref.read(positiveDatasetProvider),
        negativeDataset: ref.read(negativeDatasetProvider),
        estimatedTime: ref.read(estimatedTimeProvider),
        MET: ref.read(metProvider),
      );
    } else {
      validateInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.isEdit ? null : initDataset();

    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawerContent(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              SizedBox(
                height: 630,
                width: MediaQuery.of(context).size.width * .9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Create Exercise",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InputField(
                          inputName: " Exercise Name:",
                          textController: exerciseNameController),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            child: InputField(
                                isNumber: true,
                                inputName: " Reps:",
                                textController: repsController),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            child: InputField(
                                isNumber: true,
                                inputName: " Sets:",
                                textController: setsController),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            child: InputField(
                                isNumber: true,
                                inputName: " Estimated MET:",
                                textController: METController),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "  Intensity:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: dropDown(
                                    _intensity,
                                    selected_intensity,
                                    (String? newValue) {
                                      setState(
                                        () {
                                          selected_intensity = newValue!;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            child: InputField(
                                isNumber: true,
                                inputName: " Estimated Time(MIN):",
                                textController: estimateTimeController),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .42,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "  Parts:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: dropDown(
                                    _part,
                                    selected_part,
                                    (String? newValue) {
                                      setState(
                                        () {
                                          selected_part = newValue!;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InputField(
                        inputName: " Description / Instruction:",
                        textController: descriptionNameController,
                        isParagraph: true,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Exercise image",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              UploadImage(
                                isEdit: widget.isEdit,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Exercise video",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              UploadVideo(isEdit: widget.isEdit),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const Text(
                                "Collected Datasets",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .42,
                                    child: Center(
                                      child: InputField(
                                          isEnabled: false,
                                          inputName: " Positive:",
                                          textController:
                                              positiveDatasetController),
                                    ),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .42,
                                    child: Center(
                                      child: InputField(
                                          isEnabled: false,
                                          inputName: " Negative:",
                                          textController:
                                              negativeDatasetController),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      ElevatedButton(
                        onPressed: () {
                          saveData();
                          navigateAddDataset();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 5),
                          foregroundColor: Colors.white,
                          backgroundColor: tertiaryColor,
                        ),
                        child: const Text('Add Dataset'),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.isEdit ? editData() : submitData();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 5),
                          foregroundColor: Colors.white,
                          backgroundColor: tertiaryColor,
                        ),
                        child: const Text('Create Exercise'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
