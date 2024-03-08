enum TreeState {
  alive('🌳', '🟢'),
  burning('🔥', '🔴'),
  burned('🪵', '🟤'),
  ;

  final String emoji;
  final String debug;

  const TreeState(this.emoji, this.debug);
}
