import 'package:flutter/material.dart';
import 'package:game_of_life/constants.dart';

class CellWidget extends StatefulWidget {
  final Offset position;
  final Offset panOffset;
  final bool alive;

  const CellWidget({
    super.key,
    required this.position,
    required this.panOffset,
    required this.alive,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.dy *  kCellSize + widget.panOffset.dy, 
      left: widget.position.dx * kCellSize + widget.panOffset.dx,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          width: kCellSize,
          height: kCellSize,
          decoration: BoxDecoration(
            color: widget.alive
                ? Colors.black
                : _hovered
                    ? Colors.grey
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(0.75),
            border: Border.all(
              color: Colors.grey,
              width: 0.15,
            ),
          ),
        ),
      ),
    );
  }
}
