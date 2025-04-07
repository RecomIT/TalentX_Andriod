import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants.dart';

class SelectabelSvgIconButton extends StatelessWidget {
  final String text;
  final double textSize;
  final String svgFile;
  final Function onTapFunction;
  final double size;
  final bool isSelected;
  final double paddingVertical;

  const SelectabelSvgIconButton({
    Key key,
    @required this.text,
    @required this.svgFile,
    this.size = 55,
    this.textSize = 14,
    @required this.isSelected,
    @required this.onTapFunction,
    this.paddingVertical = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.38,
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black26,
              offset: Offset.fromDirection(Math.pi * .5, 10),
            )
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              svgFile,
              height: size,
              width: size,
              color: isSelected ? Colors.white : kPrimaryColor,
            ),
            SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                text,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: textSize),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
