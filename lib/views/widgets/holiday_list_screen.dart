import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:recom_app/utils/constants.dart';
import '../../data/models/holiday_data.dart';
import '../../services/api/api.dart';
import 'custom_table.dart';

class HolidayListScreen extends StatefulWidget {
  final ApiService apiService;
  const HolidayListScreen({
    Key key,
    @required this.apiService,
  }) : super(key: key);

  @override
  _HolidayListScreenState createState() => _HolidayListScreenState();
}

class _HolidayListScreenState extends State<HolidayListScreen> {
  Future<HolidayData> _holidayData;
  var countries = ['Bangladesh', 'India'];
  String country;
  int year = DateTime.now().year;
  // List<List<String>> holidayDataList = [];

  @override
  void initState() {
    _holidayData = widget.apiService.getHolidayList();
    super.initState();
  }

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  //left: 3,
                  right: 3,
                  top: 10,
                  bottom: 10,
                ),
                //margin: EdgeInsets.only(top: 10),
                width:
                    MediaQuery.of(context).size.width * 0.35, //double.infinity,
                child: DropdownButton<String>(
                  isDense: true,
                  underline: SizedBox(),
                  value: country,
                  hint: Text(
                    'Select Country',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500]),
                  ),
                  items: List<DropdownMenuItem<String>>.generate(
                    (countries?.length ?? 0) + 1,
                    (idx) => DropdownMenuItem<String>(
                      value: idx == 0 ? null : countries[idx - 1],
                      child: Container(
                        // width: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .width * 0.6,
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          idx == 0 ? "Select Country" : countries[idx - 1],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      if (value != null) {
                        country = value;
                      }
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 7,
                  right: 3,
                  top: 10,
                  bottom: 10,
                ),
                width:
                    MediaQuery.of(context).size.width * 0.35, //double.infinity,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                //   boxShadow: [
                //     BoxShadow(
                //       blurRadius: 15,
                //       color: Colors.black26,
                //       offset: Offset.fromDirection(Math.pi * .5, 10),
                //     ),
                //   ],
                // ),
                child: DropdownButton<int>(
                  isDense: true,
                  underline: SizedBox(),
                  value: year,
                  hint: Text(
                    'Select Year',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500]),
                  ),
                  items: List<DropdownMenuItem<int>>.generate(
                    years.length + 1,
                    (idx) => DropdownMenuItem<int>(
                      value: idx == 0 ? null : years[idx - 1],
                      child: Container(
                        //width: MediaQuery.of(context).size.width * 0.6,
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          idx == 0 ? "Select Year" : years[idx - 1].toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  onChanged: (int yr) {
                    setState(() {
                      if (yr != null) {
                        year = yr;
                      }
                      print('Year : ' + year.toString());
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          FutureBuilder<HolidayData>(
              future: _holidayData,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  List<List<String>> holidayDataList = [];
                  snapshot.data.holiday.forEach((hday) {
                    holidayDataList.add([
                      hday.date.toString().split("T")[0],
                      hday.day.substring(0, 3),
                      hday.reason +
                          '\n' +
                          (hday.note != null
                              ? hday.note.toString()
                              : ''), //+' [${hday.countryCode}] '
                      hday.countryCode
                    ]);
                  });
                  switch (country) {
                    case 'Bangladesh':
                      holidayDataList = holidayDataList
                          .where((e) =>
                              e[3] == 'BD' && e[0].contains(year.toString()))
                          .toList();
                      print(
                          'BD Holidays : ' + holidayDataList.length.toString());
                      //print(holidayDataList.toString());
                      break;
                    case 'India':
                      holidayDataList = holidayDataList
                          .where((e) =>
                              e[3] == 'IN' && e[0].contains(year.toString()))
                          .toList();
                      print('IND Holidays : ' +
                          holidayDataList.length.toString());
                      break;
                    default:
                      holidayDataList = holidayDataList
                          .where((e) =>
                              e[3] == 'BD' && e[0].contains(year.toString()))
                          .toList();
                      print('All Holidays : ' +
                          holidayDataList.length.toString());
                  }

                  return Column(
                    children: [
                      CustomTableHeader(
                        headerTitles: ["Date", "Day", "Reason"],
                        colSizes: [6, 4, 10],
                      ),
                      SizedBox(height: 5),
                      CustomTableBody(
                        colSizes: [6, 4, 10],
                        bodyData: _getTableBody(holidayDataList),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }

  List<List<String>> _getTableBody(List<List<String>> holidayDataList) {
    List<List<String>> result = [];
    holidayDataList.forEach((element) {
      element.removeAt(3); //Removing Country Code from List
      result.add(element);
    });
    return result;
  }
}
