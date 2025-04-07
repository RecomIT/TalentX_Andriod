import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  final double size;
  final Function onTapFunction;
  final String text;
  final String svgFile;
  final double paddingHorizontal;
  final double paddingVertical;
  const SvgIconButton({
    Key key,
    @required this.text,
    @required this.svgFile,
    @required this.onTapFunction,
    this.size,
    this.paddingHorizontal = 15.0,
    this.paddingVertical = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: this.onTapFunction,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: paddingVertical,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              color: Color.fromRGBO(0x43, 0x7d, 0xdd, 0.1),
            ),
            child: SvgPicture.asset(
              svgFile,
              height: size,
              width: size,
              color: const Color(0xff3ca7bd),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(0xff, 0x90, 0x97, 0xaa),
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
