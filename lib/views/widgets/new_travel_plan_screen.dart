import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/leave_type.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/data/providers/UserProvider.dart';
import 'package:recom_app/views/widgets/rounded_bottom_navbar.dart';

import '../../data/models/employee_id_list.dart';
import '../../data/models/leave_balance_chart_data.dart';
import '../../data/models/leave_request_list.dart';
import '../../data/models/user.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import 'custom_table.dart';
import 'leave_request_cell.dart';
import 'neomorphic_datetime_picker.dart';
import 'neomorphic_text_form_field.dart';
import 'wide_filled_button.dart';

class NewTravelPlanScreen extends StatefulWidget {

  @override
  _NewTravelPlanScreenState createState() => _NewTravelPlanScreenState();
}

class _NewTravelPlanScreenState extends State<NewTravelPlanScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiService _apiService;
  User _currentUser;

  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: kPrimaryColor,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Travel Plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: -1,
      ),
    );
  }
}
