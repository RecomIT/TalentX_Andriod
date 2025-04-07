import 'dart:math' as Math;

import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomTable extends StatelessWidget {
  final List<String> headerTitles;
  final List<int> colSizes;
  final List<List<String>> bodyData;

  const CustomTable({
    Key key,
    @required this.colSizes,
    @required this.headerTitles,
    @required this.bodyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(Math.pi * .5, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTableHeader(
            colSizes: colSizes,
            headerTitles: headerTitles,
          ),
          SizedBox(height: 5),
          CustomTableBody(
            colSizes: colSizes,
            bodyData: bodyData,
          ),
        ],
      ),
    );
  }
}

class CustomTableHeader extends StatelessWidget {
  final List<String> headerTitles;
  final List<int> colSizes;

  const CustomTableHeader({
    Key key,
    @required this.colSizes,
    @required this.headerTitles,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        headerTitles?.length > 0 ? headerTitles?.length : 0,
        (idx) {
          return Expanded(
            flex: colSizes[idx],
            child: Container(
              padding: EdgeInsets.only(
                top: 4,
                bottom: 4,
                left: 5,
              ),
              margin: EdgeInsets.only(
                right: idx < headerTitles?.length ? 2 : 0,
              ),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: idx == 0
                    ? BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      )
                    : idx == headerTitles.length - 1
                        ? BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          )
                        : null,
              ),
              child: Text(
                headerTitles[idx],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTableBody extends StatelessWidget {
  final List<int> colSizes;
  final List<List<String>> bodyData;

  const CustomTableBody({
    Key key,
    @required this.colSizes,
    @required this.bodyData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        bodyData?.length >0 ? bodyData?.length : 0,
        (rowId) => Row(
          children: List<Widget>.generate(
            bodyData[rowId]?.length > 0 ? bodyData[rowId]?.length: 0,
            (idx) {
              return Expanded(
                flex: colSizes[idx],
                child: Container(
                  padding: EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 5,
                  ),
                  margin: EdgeInsets.only(
                    right: idx < bodyData[rowId]?.length ? 2 : 0,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xfff3f3f3),
                    borderRadius: idx == 0
                        ? BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          )
                        : idx == bodyData[rowId].length - 1
                            ? BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )
                            : null,
                  ),
                  child: Text(
                    bodyData[rowId][idx],
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
