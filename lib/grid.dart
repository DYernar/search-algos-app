import 'dart:math';

import 'package:flutter/material.dart';

class Grid {
  List<List<Cell>> gridState = [];
  Cell start = Cell(0, 0, isStart: true);

  Grid() {
    List<List<Cell>> newgrid = [];

    for (int i = 0; i < 20; i++) {
      newgrid.add([]);
      for (int j = 0; j < 20; j++) {
        newgrid[i].add(Cell(i, j));
      }
    }

    // set starting point
    final _random = new Random();
    int startX = _random.nextInt(19);
    int startY = _random.nextInt(19);
    newgrid[startX][startY] = Cell(startX, startY, isStart: true);
    start = newgrid[startX][startY];

    // set goal point
    int goalX = _random.nextInt(19);
    int goalY = _random.nextInt(19);

    while (goalX == startX && goalY == startY) {
      goalX = _random.nextInt(19);
      goalY = _random.nextInt(19);
    }
    newgrid[goalX][goalY] = Cell(goalX, goalY, isGoal: true);

    gridState = newgrid;
  }

  bool isVisited(int x, int y) {
    return gridState[x][y].isVisited;
  }

  bool isGoal(int x, int y) {
    return gridState[x][y].isGoal;
  }

  bool isStart(int x, int y) {
    return gridState[x][y].isStart;
  }

  void setVisited(int x, int y) {
    gridState[x][y].setVisited();
  }

  void setPath(Cell p) {
    gridState[p.x][p.y].setPath();
  }

  void setObstacle(int x, int y) {
    if (gridState[x][y].isObstacle) {
      gridState[x][y].isObstacle = false;
    } else {
      gridState[x][y].isObstacle = true;
    }
  }

  bool canAdd(int x, int y) {
    return gridState[x][y].canVisit();
  }

  Color getCellColor(int x, int y) {
    var cell = gridState[x][y];
    if (cell.isPath) {
      return Colors.red;
    } else if (cell.isVisited) {
      return Colors.blue;
    } 
    return Colors.black;
  }
}

class Cell {
  final int x;
  final int y;
  bool isStart = false;
  bool isGoal = false;
  bool isObstacle = false;
  bool isVisited = false;
  bool isPath = false;

  Cell(this.x, this.y,
      {this.isStart = false,
      this.isGoal = false,
      this.isObstacle = false,
      this.isVisited = false,
      this.isPath = false});

  void setVisited() {
    isVisited = true;
  }

  void setPath() {
    isPath = true;
    isVisited = false;
  }

  bool canVisit() {
    return !isStart && !isObstacle && !isVisited;
  }
}


enum SEARCH_TYPE {
  BFS,
  DFS,
  Astar,
}