import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forest_fire/models/config.dart';
import 'package:forest_fire/models/constants.dart';
import 'package:forest_fire/models/tree.dart';
import 'package:forest_fire/models/tree_state.dart';
import 'package:forest_fire/widgets/config_dialog.dart';
import 'package:forest_fire/widgets/tree_cell.dart';

import '../models/forest.dart';

class ForestFirePage extends StatefulWidget {
  const ForestFirePage({super.key});

  @override
  State<ForestFirePage> createState() => _ForestFirePageState();
}

class _ForestFirePageState extends State<ForestFirePage> {
  Config _currentConfig = Config();
  Config? _editedConfig;
  late Forest _forest;
  late Timer _timer;
  late String message;

  @override
  void initState() {
    super.initState();

    _setTimer();
    _replant();
  }

  void _pauseResume() {
    if (_timer.isActive) {
      _timer.cancel();
    } else {
      _setTimer();
    }

    setState(() {});
  }

  void _editConfig() {
    showAdaptiveDialog<Config>(
      context: context,
      builder: (context) => ConfigDialog(_currentConfig),
    ).then((config) {
      if (config == null) return;

      setState(() {
        _editedConfig = config;
        _currentConfig = config;

        _replant();

        _timer.cancel();
        _setTimer();
      });
    });
  }

  void _reset() {
    setState(() {
      _currentConfig = _editedConfig ?? Config();

      _replant();

      _timer.cancel();
      _setTimer();
    });
  }

  void _resetRandom() {
    setState(() {
      _currentConfig = Config();
      _currentConfig.fireSpawns = List.generate(
        random.nextInt(_currentConfig.treeCount ~/ _currentConfig.forestHeight + _currentConfig.forestWidth),
        (index) => (random.nextInt(_currentConfig.forestHeight), random.nextInt(_currentConfig.forestWidth)),
      );
      _currentConfig.fireStrength = random.nextDouble();

      _replant();

      _timer.cancel();
      _setTimer();
    });
  }

  void _setTimer() {
    _timer = Timer.periodic(
      Duration(milliseconds: _currentConfig.spreadDelay),
      (timer) => _propagate(),
    );
  }

  void _replant() {
    _forest = Forest(
      _currentConfig,
      List.generate(_currentConfig.forestHeight, (x) {
        return List.generate(_currentConfig.forestWidth, (y) {
          return _currentConfig.fireSpawns.contains((x, y)) ? Tree.burning(x, y) : Tree.alive(x, y);
        });
      }),
    );

    message =
        'Setting a fire of strength ${numberFormatTwoDecimals.format(_currentConfig.fireStrength)} to ${_currentConfig.fireSpawns.length} trees in a forest of ${_currentConfig.treeCount} trees.';
  }

  void _propagate() {
    if (_forest.isOff) {
      _timer.cancel();
      return;
    }

    final newForest = Forest.clone(_currentConfig, _forest);
    for (var row in newForest.trees) {
      for (var tree in row) {
        if (tree.state == TreeState.alive && tree.shouldBurn(_forest, _currentConfig.fireStrength)) {
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
            tooltip: 'Launch a random config',
            icon: const Icon(Icons.shuffle),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          const VerticalDivider(indent: 8.0, endIndent: 8.0),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          IconButton.outlined(
            onPressed: _editConfig,
            tooltip: 'Edit the config',
            icon: const Icon(Icons.settings),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
          IconButton.outlined(
            onPressed: _reset,
            tooltip: 'Restart with the default or modified config',
            icon: const Icon(Icons.restart_alt),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          const VerticalDivider(indent: 8.0, endIndent: 8.0),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          IconButton.filled(
            onPressed: _forest.isOff ? null : _pauseResume,
            tooltip: _timer.isActive ? 'Pause' : 'Resume',
            icon: Icon(
              _timer.isActive ? Icons.pause : Icons.play_arrow,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 12.0)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(8.0),
              crossAxisCount: _currentConfig.forestWidth,
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
