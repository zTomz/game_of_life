import 'package:flutter/material.dart';
import 'package:game_of_life/constants.dart';

class CellWidget extends StatefulWidget {
  final Offset position;
  final bool alive;
  final double zoomFactor;

  const CellWidget({
    super.key,
    required this.position,
    required this.alive,
    required this.zoomFactor,
  });

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position.dy * widget.zoomFactor * kCellSize,
      left: widget.position.dx * widget.zoomFactor * kCellSize,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          width: kCellSize * widget.zoomFactor,
          height: kCellSize * widget.zoomFactor,
          decoration: BoxDecoration(
            color: widget.alive
                ? Colors.black
                : _hovered
                    ? Colors.grey
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(2 * widget.zoomFactor),
            border: Border.all(
              color: Colors.grey,
              width: 0.75 * widget.zoomFactor,
            ),
          ),
        ),
      ),
    );
  }
}
