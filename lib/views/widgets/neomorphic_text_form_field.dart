import 'dart:math' as Math;

import 'package:flutter/material.dart';

class NeomorphicTextFormField extends StatelessWidget {
  final TextInputType inputType;
  final String hintText;
  final Function onChangeFunction;
  final int numOfMaxLines;
  final bool isReadOnly;
  final Function validatorFunction;
  final String initVal;
  final double fontSize;
  const NeomorphicTextFormField({
    Key key,
    @required this.inputType,
    @required this.hintText,
    @required this.onChangeFunction,
    this.numOfMaxLines = 1,
    this.isReadOnly = false,
    this.validatorFunction,
    this.initVal,
    this.fontSize=14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black26,
            offset: Offset.fromDirection(Math.pi * .5, 4),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initVal,
        readOnly: isReadOnly,
        keyboardType: inputType ?? TextInputType.text,
        onChanged: onChangeFunction, //?? (value) => print(value),


        validator: validatorFunction,
        maxLines: numOfMaxLines,
        style: TextStyle(fontSize: fontSize,fontWeight: FontWeight.bold,color: Colors.grey[500]),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(15.0),
          hintText: hintText ?? "Enter Value",

          hintStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
          ),
        ),
      ),
    );
  }
}
//Text('To',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey[500]),)