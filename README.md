# Game of Life

This repository implements the [Conway’s Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life). I will use this to learn about Flutter performance optimizations.

### Performance

##### Settings
- Not the best benchmark, I just create the list, then draw a bit and make some evolutions.

```dart
const int kCellCount = 10000;
const int kMaxCellsPerRow = 80;
```

##### Results

- Initial commit:
    - Average: 11 FPS