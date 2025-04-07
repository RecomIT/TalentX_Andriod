import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/search_colleague_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/wide_filled_button.dart';

class ColleagueDetailPage extends StatefulWidget {
  final Colleague colleague;

  const ColleagueDetailPage({
    Key key,
    @required this.colleague,
  }) : super(key: key);
  @override
  _ColleagueDetailPageState createState() => _ColleagueDetailPageState();
}

class _ColleagueDetailPageState extends State<ColleagueDetailPage> {
  User _currentUser;
  ApiService _apiService;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ColleaguesPageScreen pageScreen;
  String msg;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    if (widget.colleague == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HOME_PAGE,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;
    // print(widget.colleague.toJson());
    // print(_currentUser.toJson());

    return Scaffold(
      key: _scaffoldKey,
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: widget.colleague == null
            ? SizedBox()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: 'Name : ${widget.colleague.name} (${widget.colleague.code})',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: 'Role : ${widget.colleague.employee_role_name}',
                            isReadOnly: true,
                          ),
                          Visibility(
                            visible: widget.colleague.iD ==_currentUser.employee_id ? true :false,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                NeomorphicTextFormField(
                                  inputType: TextInputType.multiline,
                                  numOfMaxLines: 2,
                                  hintText:
                                  'Designation : ${widget.colleague.designation}',
                                  isReadOnly: true,
                                ),
                              ],
                            ),
                          ),


                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText:
                            'Division : ${widget.colleague.division_name}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText:
                                'Department : ${widget.colleague.department}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: 'Email : ${widget.colleague.email}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: 'Phone : ${widget.colleague.phoneNo}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: 'Supervisor : ${widget.colleague.supervisor_name}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText:
                                'Location : ${widget.colleague.location_name}',
                            isReadOnly: true,
                          ),
                          SizedBox(height: 15),
                          WideFilledButton(
                              buttonText: "Back to List",
                              onTapFunction: () async {
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pop();
      //   },
      //   child: const Icon(Icons.arrow_back),
      //   backgroundColor: kPrimaryColor,
      // ),
    );
  }
}
