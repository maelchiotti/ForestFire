import 'package:flutter/material.dart';
import 'package:forest_fire/models/tree.dart';
import 'package:twemoji/twemoji.dart';

class TreeCell extends StatefulWidget {
  const TreeCell(this.tree, {super.key});

  final Tree tree;

  @override
  State<TreeCell> createState() => _TreeCellState();
}

class _TreeCellState extends State<TreeCell> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Twemoji(
        emoji: widget.tree.state.emoji,
        height: 512,
        width: 512,
      ),
    );
  }
}
