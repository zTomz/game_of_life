import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:game_of_life/constants.dart';
import 'package:game_of_life/models/cell.dart';
import 'package:game_of_life/widgets/cell_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map<Offset, bool> _cells = {};
  // ignore: prefer_final_fields
  List<Offset> _lastUpdatedOffsets = [];

  bool _panEnabled = false;
  Offset _panOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    initGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              _simulateGameOfLife();
            },
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () async {
              await initGame();
            },
            child: const Icon(Icons.restore_from_trash_rounded),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _panEnabled = !_panEnabled;
              });
            },
            child: Icon(_panEnabled ? Icons.pan_tool : Icons.pan_tool_outlined),
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.1,
        maxScale: 20.0,
        child: GestureDetector(
          onPanDown: (details) {
            if (_panEnabled) return;

            Offset pos = (details.localPosition - _panOffset) / kCellSize;
            pos = Offset(pos.dx.floorToDouble(), pos.dy.floorToDouble());

            if (!_cells.containsKey(pos)) return;

            _lastUpdatedOffsets.add(pos);

            setState(() {
              _cells[pos] = !_cells[pos]!;
            });
          },
          onPanUpdate: (details) {
            if (_panEnabled) {
              setState(() {
                _panOffset += details.delta;
              });

              return;
            }

            Offset pos = (details.localPosition - _panOffset) / kCellSize;
            pos = Offset(pos.dx.floorToDouble(), pos.dy.floorToDouble());

            if (_lastUpdatedOffsets.contains(pos)) return;
            if (!_cells.containsKey(pos)) return;

            _lastUpdatedOffsets.add(pos);

            setState(() {
              _cells[pos] = !_cells[pos]!;
            });
          },
          onPanEnd: (_) => _lastUpdatedOffsets.clear(),
          child: Stack(
            fit: StackFit.expand,
            children: _buildCells(),
          ),
        ),
      ),
    );
  }

  static Map<Offset, bool> resetGame() {
    Offset pos = const Offset(-1, 0);
    final generatedList = List.generate(
      kCellCount,
      (index) {
        pos = pos.translate(1, 0);

        if (pos.dx > kColCount - 1) {
          pos = Offset(0, pos.dy + 1);
        }

        return Cell(
          position: pos,
        );
      },
    );

    return {for (Cell cell in generatedList) cell.position: cell.alive};
  }

  Future<void> initGame() async {
    _cells = await Isolate.run<Map<Offset, bool>>(() => resetGame());

    // Center the game on the screen
    if (context.mounted) {
      // Calculate the size of the cells stack
      const cellStack = Size(kCellSize * kColCount, kCellSize * kRowCount);
      // We ignore, because we know that context is mounted, but the analyzer don't
      // ignore: use_build_context_synchronously
      final screenSize = MediaQuery.sizeOf(context);

      _panOffset = Offset(
        (screenSize.width - cellStack.width) / 2,
        (screenSize.height - cellStack.height) / 2,
      );
    }

    setState(() {});
  }

  List<Widget> _buildCells() {
    List<Widget> cells = [];

    for (MapEntry<Offset, bool> cell in _cells.entries) {
      cells.add(
        CellWidget(
          position: cell.key,
          panOffset: _panOffset,
          alive: cell.value,
        ),
      );
    }

    return cells;
  }

  void _simulateGameOfLife() {
    Map<Offset, bool> nextGen = {};

    for (MapEntry<Offset, bool> cell in _cells.entries) {
      final neighbors = _calculateNeighbors(cell.key);

      if (neighbors == 3 && !cell.value) {
        nextGen[cell.key] = true;
      } else if (neighbors < 2 || neighbors > 3 && cell.value) {
        nextGen[cell.key] = false;
      } else {
        nextGen[cell.key] = cell.value;
      }
    }

    setState(() {
      _cells = nextGen;
    });
  }

  int _calculateNeighbors(Offset pos) {
    int neighbors = 0;

    // Left side
    if (_cells[pos.translate(-1, -1)] ?? false) {
      neighbors++;
    }
    if (_cells[pos.translate(-1, 0)] ?? false) {
      neighbors++;
    }
    if (_cells[pos.translate(-1, 1)] ?? false) {
      neighbors++;
    }

    // Middle
    if (_cells[pos.translate(0, -1)] ?? false) {
      neighbors++;
    }
    if (_cells[pos.translate(0, 1)] ?? false) {
      neighbors++;
    }

    // Right side
    if (_cells[pos.translate(1, -1)] ?? false) {
      neighbors++;
    }
    if (_cells[pos.translate(1, 0)] ?? false) {
      neighbors++;
    }
    if (_cells[pos.translate(1, 1)] ?? false) {
      neighbors++;
    }

    return neighbors;
  }
}
