import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class WideFilledButton extends StatelessWidget {
  final String buttonText;
  final Function onTapFunction;
  final Color fillColor;
  final Color textColor;

  WideFilledButton({
    @required this.buttonText,
    @required this.onTapFunction,
    this.fillColor,
    this.textColor,
  });

  @override
  InkWell build(BuildContext context) {
    return InkWell(
      onTap: this.onTapFunction,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fillColor == null ? kPrimaryColor : fillColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          this.buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor == null ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}
