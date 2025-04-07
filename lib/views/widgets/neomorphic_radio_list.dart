import 'dart:math' as Math;

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class NeomorphicRadio extends StatelessWidget {
  final String value;
  final bool isSelected;
  final Function onChangeFunction;
  const NeomorphicRadio({
    Key key,
    @required this.value,
    @required this.isSelected,
    @required this.onChangeFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChangeFunction,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                  offset: Offset.fromDirection(Math.pi * .5, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
