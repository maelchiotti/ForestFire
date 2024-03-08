import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forest_fire/models/config.dart';
import 'package:forest_fire/models/constants.dart';
import 'package:forest_fire/models/tree.dart';
import 'package:forest_fire/models/tree_state.dart';
import 'package:forest_fire/widgets/tree_cell.dart';

import '../models/forest.dart';

class ForestFirePage extends StatefulWidget {
  const ForestFirePage({super.key});

  @override
  State<ForestFirePage> createState() => _ForestFirePageState();
}

class _ForestFirePageState extends State<ForestFirePage> {
  Config _config = Config();
  late Forest _forest;
  late Timer _timer;
  late String message;

  @override
  void initState() {
    super.initState();

    _setTimer();
    _replant();
  }

  void _resetDefault() {
    setState(() {
      _config = Config();

      _replant();

      _timer.cancel();
      _setTimer();
    });
  }

  void _resetRandom() {
    setState(() {
      _config = Config();
      _config.fireSpawns = List.generate(
        random.nextInt(_config.treeCount ~/ _config.forestHeight + _config.forestWidth),
        (index) => (random.nextInt(_config.forestHeight), random.nextInt(_config.forestWidth)),
      );
      _config.fireStrength = random.nextDouble();

      _replant();

      _timer.cancel();
      _setTimer();
    });
  }

  void _setTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: _config.spreadDelay),
      (timer) => _propagate(),
    );
  }

  void _replant() {
    _forest = Forest(
      _config,
      List.generate(_config.forestHeight, (x) {
        return List.generate(_config.forestWidth, (y) {
          return _config.fireSpawns.contains((x, y)) ? Tree.burning(x, y) : Tree.alive(x, y);
        });
      }),
    );

    message =
        'Setting a fire of strength ${numberFormatTwoDecimals.format(_config.fireStrength)} to ${_config.fireSpawns.length} trees in a forest of ${_config.treeCount} trees.';
  }

  void _propagate() {
    if (_forest.isOff) {
      _timer.cancel();
      return;
    }

    final newForest = Forest.clone(_config, _forest);
    for (var row in newForest.trees) {
      for (var tree in row) {
        if (tree.state == TreeState.alive && tree.shouldBurn(_forest, _config.fireStrength)) {
          tree.state = TreeState.burning;
        } else if (tree.state == TreeState.burning) {
          tree.state = TreeState.burned;
        }
      }
    }

    setState(() {
      _forest = newForest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final treeCells = <Widget>[];
    for (var row in _forest.trees) {
      for (var tree in row) {
        treeCells.add(TreeCell(tree));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Forest Fire'),
        actions: [
          IconButton.outlined(
            onPressed: _resetRandom,
            icon: const Icon(Icons.shuffle),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
          IconButton.outlined(
            onPressed: _resetDefault,
            icon: const Icon(Icons.restart_alt),
          ),
          const Padding(padding: EdgeInsets.only(right: 12)),
        ],
      ),
      body: Column(
        children: [
          Text(message),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(8),
              crossAxisCount: _config.forestWidth,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              children: treeCells,
            ),
          ),
        ],
      ),
    );
  }
}
