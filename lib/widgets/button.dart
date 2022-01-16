import 'package:flutter/material.dart';

Widget buildButton(String text, Function onTap) {
  return Container(
    margin: EdgeInsets.all(5),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget buildStartCell() {
  return Container(
    child: Center(
      child: Text(
        "S",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    color: Colors.white,
  );
}

Widget buildGoalCell() {
  return Container(
    child: Center(
      child: Text(
        "G",
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    color: Colors.white,
  );
}
