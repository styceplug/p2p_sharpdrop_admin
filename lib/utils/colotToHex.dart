import 'dart:ui';

import 'package:flutter/material.dart';

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

String colorString(Color color) {
  if (color == Colors.red) return 'Red';
  if (color == Colors.blue) return 'Blue';
  if (color == Colors.green) return 'Green';
  if (color == Colors.orange) return 'Orange';
  if (color == Colors.purple) return 'Purple';
  if (color == Colors.pink) return 'Pink';
  if (color == Colors.teal) return 'Teal';
  if (color == Colors.cyan) return 'Cyan';
  if (color == Colors.yellow) return 'Yellow';
  if (color == Colors.brown) return 'Brown';
  if (color == Colors.indigo) return 'Indigo';
  if (color == Colors.lime) return 'Lime';
  if (color == Colors.amber) return 'Amber';
  if (color == Colors.deepOrange) return 'Deep Orange';
  if (color == Colors.deepPurple) return 'Deep Purple';
  if (color == Colors.lightBlue) return 'Light Blue';
  if (color == Colors.lightGreen) return 'Light Green';
  if (color == Colors.grey) return 'Grey';
  if (color == Colors.blueGrey) return 'Blue Grey';
  if (color == Colors.black) return 'Black';
  return colorToHex(color);
}