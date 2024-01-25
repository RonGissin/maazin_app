import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeScreen extends StatefulWidget {
  const SnakeScreen({super.key, required this.snakeColor});

  final Color snakeColor;
  @override
  _SnakeScreenState createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  // Game settings
  final int squaresPerRow = 20;
  final int squaresPerCol = 40;
  final double squareSize = 10.0;
  final int gameSpeed = 200; // Lower is faster

  Color foodColor = Colors.red;
  
  // Game variables
  List<int> snakePositions = [0, 1, 2]; // Initial snake
  int foodPosition = 55;
  String direction = 'right';
  int score = 0;
  Timer? timer;
  Random random = Random();

  void startGame() {
    var duration = Duration(milliseconds: gameSpeed);
    snakePositions = [45, 65, 85, 105, 125]; // Initial snake position
    direction = 'down'; // Initial direction
    score = 0; // Initial score

    // Setting timer to repeatedly call moveSnake function
    timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        moveSnake();
        checkGameOver();
      });
    });

    generateNewFood();
  }

  void moveSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePositions.last > squaresPerRow * (squaresPerCol - 1)) {
            snakePositions.add(snakePositions.last + squaresPerRow - (squaresPerRow * squaresPerCol));
          } else {
            snakePositions.add(snakePositions.last + squaresPerRow);
          }
          break;
        case 'up':
          if (snakePositions.last < squaresPerRow) {
            snakePositions.add(snakePositions.last - squaresPerRow + (squaresPerRow * squaresPerCol));
          } else {
            snakePositions.add(snakePositions.last - squaresPerRow);
          }
          break;
        case 'left':
          if (snakePositions.last % squaresPerRow == 0) {
            snakePositions.add(snakePositions.last - 1 + squaresPerRow);
          } else {
            snakePositions.add(snakePositions.last - 1);
          }
          break;
        case 'right':
          if ((snakePositions.last + 1) % squaresPerRow == 0) {
            snakePositions.add(snakePositions.last + 1 - squaresPerRow);
          } else {
            snakePositions.add(snakePositions.last + 1);
          }
          break;
        default:
      }

      if (snakePositions.last == foodPosition) {
        score += 1;
        generateNewFood();
      } else {
        snakePositions.removeAt(0);
      }
    });
  }

  void generateNewFood() {
    foodPosition = random.nextInt(squaresPerRow * squaresPerCol);
    while (snakePositions.contains(foodPosition)) {
      foodPosition = random.nextInt(squaresPerRow * squaresPerCol);
    }

    // Generate a new random color for the food
    foodColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  void resetGame() {
    setState(() {
      snakePositions = [45, 65, 85, 105, 125]; // Reset to initial snake position
      direction = 'down'; // Reset to initial direction
      score = 0; // Reset score
      generateNewFood(); // Generate new food
    });
    startGame(); // Restart the game
  }


  void checkGameOver() {
    if (snakePositions.length != snakePositions.toSet().length) {
      timer?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your score: $score'),
            actions: <Widget>[
              TextButton(
                child: const Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  resetGame(); // Reset the game state and start a new game
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game - Score: $score'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Adds padding around the game board
        child: Center(
          child: AspectRatio(
            aspectRatio: squaresPerRow / squaresPerCol, // Maintains the aspect ratio of the game board
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: squaresPerRow,
                  childAspectRatio: 1, // Ensures squares are square-shaped
                ),
                itemCount: squaresPerRow * squaresPerCol,
                itemBuilder: (BuildContext context, int index) {
                  Color color;
                  if (snakePositions.contains(index)) {
                    color = widget.snakeColor; // Snake color
                  } else if (index == foodPosition) {
                    color = foodColor; // Current food color
                  } else {
                    color = Colors.lightGreen[100]!; // Background color
                  }

                  return Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.rectangle,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

}
