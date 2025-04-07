import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants.dart';

class SmallSelectabelSvgIconButton extends StatelessWidget {
  final String text;
  final String svgFile;
  final Function onTapFunction;
  final bool isSelected;

  const SmallSelectabelSvgIconButton({
    Key key,
    @required this.text,
    @required this.svgFile,
    @required this.isSelected,
    @required this.onTapFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? kSecondaryColor : Color.fromRGBO(0x43, 0x7D, 0xDD, 0.15),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              svgFile,
              color: isSelected ? Colors.white : kPrimaryColor,
              width: 50,

            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? kSecondaryColor : Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
