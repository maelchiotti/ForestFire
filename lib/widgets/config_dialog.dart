import 'package:flutter/material.dart';
import 'package:forest_fire/models/config.dart';

class ConfigDialog extends StatelessWidget {
  const ConfigDialog(this.config, {super.key});

  final Config config;

  @override
  Widget build(BuildContext context) {
    final forestWidthController = TextEditingController(text: config.forestWidth.toString());
    final forestHeightController = TextEditingController(text: config.forestHeight.toString());
    final spreadDelayController = TextEditingController(text: config.spreadDelay.toString());
    final fireStrengthController = TextEditingController(text: config.fireStrength.toString());
    final fireSpawnsController = TextEditingController(text: config.fireSpawnsToString);

    final defaultConfig = Config();

    return AlertDialog(
      title: const Text('Config'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextField(
              decoration: InputDecoration(
                label: const Text('Forest width'),
                hintText: defaultConfig.forestWidth.toString(),
              ),
              controller: forestWidthController,
            ),
            TextField(
              decoration: InputDecoration(
                label: const Text('Forest height'),
                hintText: defaultConfig.forestHeight.toString(),
              ),
              controller: forestHeightController,
            ),
            TextField(
              decoration: InputDecoration(
                label: const Text('Spread delay'),
                hintText: defaultConfig.spreadDelay.toString(),
              ),
              controller: spreadDelayController,
            ),
            TextField(
              decoration: InputDecoration(
                label: const Text('Fire strength'),
                hintText: defaultConfig.fireStrength.toString(),
              ),
              controller: fireStrengthController,
            ),
            TextField(
              decoration: InputDecoration(
                label: const Text('Fire spawns'),
                hintText: defaultConfig.fireSpawnsToString,
              ),
              controller: fireSpawnsController,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final fireSpawns = fireSpawnsController.text.split(';').map((e) {
              final record = e.split(',').map((e) {
                return int.parse(e);
              }).toList();

              return (record[0], record[1]);
            }).toList();

            final config = Config(
              forestWidth: int.parse(forestWidthController.text),
              forestHeight: int.parse(forestHeightController.text),
              spreadDelay: int.parse(spreadDelayController.text),
              fireStrength: double.parse(fireStrengthController.text),
              fireSpawns: fireSpawns,
            );
            Navigator.of(context).pop(config);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
