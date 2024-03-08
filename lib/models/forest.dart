import 'package:forest_fire/models/tree.dart';
import 'package:forest_fire/models/tree_state.dart';

import 'config.dart';

class Forest {
  final Config config;
  final List<List<Tree>> trees;

  Forest(this.config, this.trees);

  factory Forest.clone(Config config, Forest forest) {
    final List<List<Tree>> newTrees = [];

    for (int x = 0; x < config.forestHeight; x++) {
      newTrees.add([]);
      for (int y = 0; y < config.forestWidth; y++) {
        newTrees[x].add(Tree.clone(forest.get(x, y)));
      }
    }

    return Forest(config, newTrees);
  }

  bool get isOff {
    return trees.every((row) {
      return row.every((tree) {
        return tree.state != TreeState.burning;
      });
    });
  }

  Tree get(int x, int y) {
    return trees[x][y];
  }

  void set(int x, int y, Tree tree) {
    trees[x][y] = tree;
  }

  @override
  String toString() {
    return trees.toString();
  }
}
