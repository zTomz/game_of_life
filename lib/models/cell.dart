import 'package:flutter/material.dart';

class Cell {
  final Offset position;
  bool alive;

  Cell({
    required this.position,
    this.alive = false,
  });

  @override
  String toString() {
    return 'Cell(position: $position, alive: $alive)';
  }
}
