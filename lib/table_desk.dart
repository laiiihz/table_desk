library table_desk;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'table_desk_row.dart';
part 'table_desk_column.dart';

class TableDesk extends StatelessWidget {
  const TableDesk({
    super.key,
    required this.child,
    required this.shape,
  });

  final Widget child;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: shape,
      child: child,
    );
  }
}
