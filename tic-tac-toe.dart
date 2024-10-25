import 'dart:io';
import 'dart:math';

class TicTacToe {
  List<List<String>> board;
  String currentPlayer;

  TicTacToe()
      : board = List.generate(3, (_) => List.filled(3, ' ')),
        currentPlayer = 'X';

  void printBoard() {
    print('Current board:');
    for (var row in board) {
      print(row);
    }
  }

  bool makeMove(int row, int col) {
    if (board[row][col] == ' ') {
      board[row][col] = currentPlayer;
      return true;
    }
    return false;
  }

  bool checkWin() {
    for (int i = 0; i < 3; i++) {
      if ((board[i][0] == currentPlayer &&
          board[i][1] == currentPlayer &&
          board[i][2] == currentPlayer) ||
          (board[0][i] == currentPlayer &&
          board[1][i] == currentPlayer &&
          board[2][i] == currentPlayer)) {
        return true;
      }
    }
    return (board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer);
  }

  bool isDraw() {
    return board.every((row) => row.every((cell) => cell != ' '));
  }

  void switchPlayer() {
    currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
  }

  void playTwoPlayer() {
    while (true) {
      printBoard();
      print("Player $currentPlayer, enter row and column (0, 1, 2):");
      var input = stdin.readLineSync();
      var parts = input!.split(' ');
      int row = int.parse(parts[0]);
      int col = int.parse(parts[1]);

      if (makeMove(row, col)) {
        if (checkWin()) {
          printBoard();
          print('Player $currentPlayer wins!');
          break;
        }
        if (isDraw()) {
          printBoard();
          print('It\'s a draw!');
          break;
        }
        switchPlayer();
      } else {
        print('Invalid move! Try again.');
      }
    }
  }

  void playAgainstComputer(bool isHard) {
    while (true) {
      printBoard();
      if (currentPlayer == 'X') {
        print("Player X, enter row and column (0, 1, 2):");
        var input = stdin.readLineSync();
        var parts = input!.split(' ');
        int row = int.parse(parts[0]);
        int col = int.parse(parts[1]);

        if (makeMove(row, col)) {
          if (checkWin()) {
            printBoard();
            print('Player X wins!');
            break;
          }
          if (isDraw()) {
            printBoard();
            print('It\'s a draw!');
            break;
          }
          switchPlayer();
        } else {
          print('Invalid move! Try again.');
        }
      } else {
        List<int> bestMove;
        if (isHard) {
          bestMove = minimax(board, 'O');
          makeMove(bestMove[1], bestMove[2]);
        } else {
          do {
            bestMove = [Random().nextInt(3), Random().nextInt(3)];
          } while (!makeMove(bestMove[0], bestMove[1]));
        }

        if (checkWin()) {
          printBoard();
          print('Player O wins!');
          break;
        }
        if (isDraw()) {
          printBoard();
          print('It\'s a draw!');
          break;
        }
        switchPlayer();
      }
    }
  }

  List<int> minimax(List<List<String>> board, String player) {
    if (checkWin()) {
      return [player == 'O' ? 1 : -1, -1, -1];
    }
    if (isDraw()) {
      return [0, -1, -1];
    }

    List<int> bestMove = [-1, -1, -1];
    int bestScore = (player == 'O') ? -100 : 100;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          board[i][j] = player; 
          List<int> score = minimax(board, player == 'O' ? 'X' : 'O');
          board[i][j] = ' ';

          if (player == 'O') {
            if (score[0] > bestScore) {
              bestScore = score[0];
              bestMove = [bestScore, i, j];
            }
          } else {
            if (score[0] < bestScore) {
              bestScore = score[0];
              bestMove = [bestScore, i, j];
            }
          }
        }
      }
    }
    return bestMove;
  }
}

void main() {
  print("Choose mode: 1. Two Player 2. Player vs Computer (easy) 3. Player vs Computer (hard)");
  var mode = stdin.readLineSync();

  var game = TicTacToe();

  if (mode == '1') {
    game.playTwoPlayer();
  } else if (mode == '2') {
    game.playAgainstComputer(false);
  } else if (mode == '3') {
    game.playAgainstComputer(true);
  }
}

