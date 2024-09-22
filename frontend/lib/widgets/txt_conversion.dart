import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TextConversion extends StatefulWidget {
  // final List<List<List<double>>> data;

  const TextConversion({
    super.key,
    // required this.data,
  });

  @override
  State<TextConversion> createState() => _TextConversionState();
}

class _TextConversionState extends State<TextConversion> {
  Future<void> translateCollectedDatatoTxt2(
    Map<String, dynamic> inputs,
  ) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(inputs['token']);
    Directory externalDir = await getApplicationDocumentsDirectory();
    String externalPath = externalDir.path;
    String filePath = '$externalPath/coordinatesCollected.txt';
    File file = File(filePath);
    file.writeAsStringSync('');
    // ignore: unused_local_variable
    int progressCtr = 0;

    for (List exerciseSet in inputs['coordinates']) {
      progressCtr++;

      await file.writeAsString('START\n', mode: FileMode.append);

      for (List sequence in exerciseSet) {
        for (double individualCoordinate in sequence) {
          if (individualCoordinate.toString().length > 10) {
            await file.writeAsString(
                '${individualCoordinate.toString().substring(0, 10)}|',
                mode: FileMode.append);
          } else {
            await file.writeAsString('${individualCoordinate.toString()}|',
                mode: FileMode.append);
          }
        }
        await file.writeAsString('\n', mode: FileMode.append);
        // }
        await file.writeAsString('END\n', mode: FileMode.append);
        // print(
        // "=========================================================================");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text('Downloading...'),
        const SizedBox(height: 20),
        SizedBox(
          width: 200, // Specify a fixed width
          child: LinearProgressIndicator(
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            value: 0.5,
          ),
        ),
      ],
    );
  }
}
