import 'package:flutter/material.dart';

class Toggle extends StatefulWidget {
  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  List<bool> isSelected = [true, false]; // Initial selection

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ToggleButtons(
          borderRadius: BorderRadius.circular(20.0),
          isSelected: isSelected,
          selectedColor: Colors.black,
          fillColor: Color(0xFFD8FC4D), // Lime green for selected background
          color: Colors.black,
          renderBorder: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Open days'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Blocked'),
            ),
          ],
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < isSelected.length; i++) {
                isSelected[i] = i == index;
              }
            });
          },
        )
    );
  }
}
