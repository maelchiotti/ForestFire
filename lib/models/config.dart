class Config {
  int forestWidth;
  int forestHeight;
  int spreadDelay;
  double fireStrength;
  List<(int, int)> fireSpawns;

  Config({
    this.forestWidth = 30,
    this.forestHeight = 16,
    this.spreadDelay = 500,
    this.fireStrength = 0.25,
    this.fireSpawns = const [(8, 15)],
  });

  int get treeCount => forestWidth * forestHeight;

  String get fireSpawnsToString {
    return fireSpawns.map((point) {
      return '${point.$1},${point.$2}';
    }).join(' ; ');
  }
}
