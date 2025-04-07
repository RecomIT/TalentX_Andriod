import 'dart:math' as Math;

import 'package:flutter/material.dart';

import '../../data/models/all_leave_report.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import 'custom_table.dart';
import 'neomorphic_text_form_field.dart';

class ViewLeaveScreen extends StatefulWidget {
  const ViewLeaveScreen({
    Key key,
    @required ApiService apiService,
  })  : _apiService = apiService,
        super(key: key);

  final ApiService _apiService;

  @override
  _ViewLeaveScreenState createState() => _ViewLeaveScreenState();
}

class _ViewLeaveScreenState extends State<ViewLeaveScreen> {
  String searchText;
  AllLeaveReport selectedLeaveReport;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            child: FutureBuilder<List<AllLeaveReport>>(
              future: widget._apiService.getAllLeaveReportList(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return Container(
                    width: double.infinity,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Leave Info",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 15),
                        NeomorphicTextFormField(
                          inputType: TextInputType.text,
                          hintText: "Employee ID",
                          onChangeFunction: (String text) {
                            setState(() {
                              searchText = text;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: Math.min(
                              150,
                              snapshot.data
                                      .where((lvRpt) =>
                                          searchText != null && searchText.length > 0 && lvRpt.id.contains(searchText))
                                      .length *
                                  40.0),
                          child: ListView(
                            children: snapshot.data
                                .where((lvRpt) =>
                                    searchText != null && searchText.length > 0 && lvRpt.id.contains(searchText))
                                .map(
                                  (lvRpt) => InkWell(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        selectedLeaveReport = lvRpt;
                                        searchText = "";
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 7,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5,
                                            color: Colors.black12,
                                            offset: Offset.fromDirection(Math.pi * .5, 10),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lvRpt.id.length == 1 ? "0" + lvRpt.id : lvRpt.id,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            lvRpt.name,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox();
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SizedBox(height: 30),
          selectedLeaveReport == null
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black12,
                        offset: Offset.fromDirection(Math.pi * .5, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "General Info",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      InfoTableCell("ID", selectedLeaveReport.id ?? " "),
                      InfoTableCell("Name", selectedLeaveReport.name ?? " "),
                      InfoTableCell("Department", selectedLeaveReport.department ?? " "),
                      InfoTableCell("Designation", selectedLeaveReport.designation ?? " "),
                      InfoTableCell("DOJ", selectedLeaveReport.joiningDate?.split("T")?.first ?? " "),
                      InfoTableCell("Mobile", selectedLeaveReport.mobile ?? " "),
                      InfoTableCell("Email", selectedLeaveReport.email ?? " "),
                    ],
                  ),
                ),
          SizedBox(height: 30),
          selectedLeaveReport == null
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 5,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Leave Balance",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomTable(
                        colSizes: [7, 5, 4, 4],
                        headerTitles: ["Leave Type", "Allocated", "Consumed", "Remaining"],
                        bodyData: [
                          [
                            'Annual Leave',
                            selectedLeaveReport.annualLeaveAllocated.toString(),
                            selectedLeaveReport.annualLeaveAvailed.toString(),
                            selectedLeaveReport.annualLeaveBalance.toString()
                          ],
                          [
                            'Casual Leave',
                            selectedLeaveReport.casualLeaveAllocated.toString(),
                            selectedLeaveReport.casualLeaveAvailed.toString(),
                            selectedLeaveReport.casualLeaveBalance.toString()
                          ],
                          [
                            'Sick Leave',
                            selectedLeaveReport.sickLeaveAllocated.toString(),
                            selectedLeaveReport.sickLeaveAvailed.toString(),
                            selectedLeaveReport.sickLeaveBalance.toString()
                          ],
                          [
                            'Unpaid Leave',
                            selectedLeaveReport.unpaidLeaveAllocated.toString(),
                            selectedLeaveReport.unpaidLeaveAvailed.toString(),
                            selectedLeaveReport.unpaidLeaveBalance.toString()
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class InfoTableCell extends StatelessWidget {
  final String label;
  final String text;
  InfoTableCell(this.label, this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(
                top: 6,
                bottom: 6,
                left: 5,
              ),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: EdgeInsets.only(
                top: 6,
                bottom: 6,
                left: 5,
              ),
              decoration: BoxDecoration(
                color: Color(0xfff3f3f3),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
