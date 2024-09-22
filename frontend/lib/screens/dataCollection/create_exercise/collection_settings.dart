import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionSettings extends ConsumerStatefulWidget {
  const CollectionSettings({
    super.key,
    this.onChangeNoMovementBuffer,
    this.onChangeChangeRange,
  });

  final Function(int)? onChangeNoMovementBuffer;
  final Function(double)? onChangeChangeRange;

  @override
  ConsumerState<CollectionSettings> createState() => _CollectionSettingsState();
}

class _CollectionSettingsState extends ConsumerState<CollectionSettings> {
  double _noMovementBuffer = 20.0;
  double _changeRange = 20.0;

  void settings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use a StatefulBuilder to manage state within the dialog
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Settings'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'No Movement Buffer: ${_noMovementBuffer.toStringAsFixed(2)}'),
                        Slider(
                          value: _noMovementBuffer,
                          min: 0.0,
                          max: 50.0,
                          divisions: 50,
                          label: _noMovementBuffer.toStringAsFixed(2),
                          onChanged: (value) {
                            widget.onChangeNoMovementBuffer!(value.toInt());
                            setState(
                              () {
                                _noMovementBuffer = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'No Movement Buffer: ${_changeRange.toStringAsFixed(2)}'),
                        Slider(
                          value: _changeRange,
                          min: 0.0,
                          max: 100.0,
                          divisions: 20,
                          label: _changeRange.toStringAsFixed(2),
                          onChanged: (value) {
                            widget.onChangeChangeRange!(value / 1000);

                            setState(
                              () {
                                _changeRange = value;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.grey, // Replace with your secondaryColor
      ),
      onPressed: () {
        settings(); // Open the dialog when button is pressed
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Slider Dialog Example')),
        body: const Center(
          child: CollectionSettings(),
        ),
      ),
    ),
  );
}
