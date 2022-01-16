import 'package:flutter/material.dart';
import 'package:search_algos/grid.dart';
import 'package:search_algos/widgets/button.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> speeds = [1000, 500, 200, 50, 10];
  SEARCH_TYPE _searchType = SEARCH_TYPE.BFS;
  late Grid grid;
  int speed = 1;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    grid = Grid();
  }

  _setAlgoType(SEARCH_TYPE newType) {
    setState(() {
      _searchType = newType;
    });
  }

  _selectSearchType() {
    if (isSearching) return;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                "BFS",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _setAlgoType(SEARCH_TYPE.BFS);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "DFS",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _setAlgoType(SEARCH_TYPE.DFS);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                "A*",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                _setAlgoType(SEARCH_TYPE.Astar);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _generateNewGrid() {
    if (isSearching) return;
    setState(() {
      grid = Grid();
    });
  }

  void startSearch() {
    if (isSearching) return;
    setState(() {
      isSearching = true;
    });
    if (_searchType == SEARCH_TYPE.BFS) {
      _bfsSearch();
      return;
    }
    setState(() {
      isSearching = false;
    });
  }

  Future<void> _bfsSearch() async {
    List<Cell> queue = [];
    queue.add(grid.start);
    var parent = {};
    Cell? goal;

    int i = 0;
    while (queue.isNotEmpty) {
      print("I IS $i");
      // get first element from the queue
      Cell current = queue.first;
      queue.removeAt(0);
      // if current element is a goal stop while and call buildpath based on a parent
      if (grid.isGoal(current.x, current.y)) {
        goal = current;
        break;
      }
      if (current.isVisited) {
        continue;
      }
      // add its childs to a queue
      // set its childs parent as a current node
      if (current.x < 19) {
        if (grid.canAdd(current.x + 1, current.y)) {
          var newCell = grid.gridState[current.x + 1][current.y];
          parent[newCell] = current;
          queue.add(newCell);
        }
      }

      if (current.x > 0) {
        if (grid.canAdd(current.x - 1, current.y)) {
          var newCell = grid.gridState[current.x - 1][current.y];
          parent[newCell] = current;
          queue.add(newCell);
        }
      }

      if (current.y > 0) {
        if (grid.canAdd(current.x, current.y - 1)) {
          var newCell = grid.gridState[current.x][current.y - 1];
          parent[newCell] = current;
          queue.add(newCell);
        }
      }

      if (current.y < 19) {
        if (grid.canAdd(current.x, current.y + 1)) {
          var newCell = grid.gridState[current.x][current.y + 1];
          parent[newCell] = current;
          queue.add(newCell);
        }
      }

      if (!grid.isStart(current.x, current.y)) {
        print(
            "$i x: ${current.x} y: ${current.y} isvisited: ${current.isVisited} ");
        i++;
        setState(() {
          current.setVisited();
        });
      }

      await Future.delayed(Duration(milliseconds: speeds[speed]));
    }

    if (goal == null) {
      setState(() {
        isSearching = false;
      });
      return;
    }

    var path = [];
    while (parent[goal] != null) {
      path.add(parent[goal]);
      goal = parent[goal];
    }

    for (Cell p in path) {
      if (!grid.isStart(p.x, p.y)) {
        grid.setPath(p);
        setState(() {});
      }
    }
    setState(() {
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildGameBody(),
    );
  }

  Widget _buildGameBody() {
    int gridStateLength = grid.gridState.length;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 500,
            height: 500,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              color: Colors.black,
            ),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridStateLength,
              ),
              itemBuilder: _buildGridItems,
              itemCount: gridStateLength * gridStateLength,
            ),
          ),
          buildButton("generate new grid", _generateNewGrid),
          buildButton("Algorithm: $_searchType", _selectSearchType),
          buildButton("start search", () {
            startSearch();
          }),
          Text(
            "Speed: x$speed",
            style: TextStyle(color: Colors.white),
          ),
          buildButton('+', () {
            if (speed < 4) {
              setState(() {
                speed++;
              });
            }
          }),
          buildButton('-', () {
            if (speed > 0) {
              setState(() {
                speed--;
              });
            }
          }),
        ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = grid.gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5)),
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: grid.getCellColor(x, y),
              ),
              child: _buildGridItem(x, y),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    var cell = grid.gridState[x][y];
    if (cell.isStart) {
      return buildStartCell();
    } else if (cell.isGoal) {
      return buildGoalCell();
    } else if (cell.isObstacle) {
      return Container(color: Colors.grey);
    }
    return Container();
  }

  _gridItemTapped(int x, int y) {
    grid.setObstacle(x, y);
    setState(() {});
  }
}
