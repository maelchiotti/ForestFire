import 'package:flutter/material.dart';
import 'package:forest_fire/models/forest.dart';
import 'package:forest_fire/models/tree_state.dart';

import 'constants.dart';

class Tree extends ChangeNotifier {
  final int row;
  final int column;
  TreeState state;

  Tree.alive(this.row, this.column) : state = TreeState.alive;

  Tree.burning(this.row, this.column) : state = TreeState.burning;

  Tree.burned(this.row, this.column) : state = TreeState.burned;

  factory Tree.clone(Tree tree) {
    switch (tree.state) {
      case TreeState.alive:
        return Tree.alive(tree.row, tree.column);
      case TreeState.burning:
        return Tree.burning(tree.row, tree.column);
      case TreeState.burned:
        return Tree.burned(tree.row, tree.column);
    }
  }

  bool shouldBurn(Forest forest, double fireForce) {
    double nextToFireCoefficient = 0;
    if (column - 1 >= 0 && forest.get(row, column - 1).state == TreeState.burning) {
      nextToFireCoefficient += 1 / 6;
    } else if (column + 1 < forest.config.forestWidth && forest.get(row, column + 1).state == TreeState.burning) {
      nextToFireCoefficient += 1 / 6;
    } else if (row - 1 >= 0 && forest.get(row - 1, column).state == TreeState.burning) {
      nextToFireCoefficient += 1 / 6;
    } else if (row + 1 < forest.config.forestHeight && forest.get(row + 1, column).state == TreeState.burning) {
      nextToFireCoefficient += 1 / 6;
    }

    double diagonalToFireCoefficient = 0;
    if (row - 1 >= 0 && column - 1 >= 0 && forest.get(row - 1, column - 1).state == TreeState.burning) {
      diagonalToFireCoefficient += 1 / 12;
    } else if (row - 1 >= 0 &&
        column + 1 < forest.config.forestWidth &&
        forest.get(row - 1, column + 1).state == TreeState.burning) {
      diagonalToFireCoefficient += 1 / 12;
    } else if (row + 1 < forest.config.forestHeight &&
        column - 1 >= 0 &&
        forest.get(row + 1, column - 1).state == TreeState.burning) {
      diagonalToFireCoefficient += 1 / 12;
    } else if (row + 1 < forest.config.forestHeight &&
        column + 1 < forest.config.forestWidth &&
        forest.get(row + 1, column + 1).state == TreeState.burning) {
      diagonalToFireCoefficient += 1 / 12;
    }

    final totalFireCoefficient = nextToFireCoefficient + diagonalToFireCoefficient;
    return totalFireCoefficient > 0 && random.nextDouble() * fireForce > totalFireCoefficient;
  }

  @override
  String toString() {
    return state.debug;
  }
}
