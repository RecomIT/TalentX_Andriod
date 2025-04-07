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

class MsgColleaguesPage extends StatefulWidget {
  final Colleague colleague;

  const MsgColleaguesPage({
    Key key,
    @required this.colleague,
  }) : super(key: key);
  @override
  _MsgColleaguesPageState createState() => _MsgColleaguesPageState();
}

class _MsgColleaguesPageState extends State<MsgColleaguesPage> {
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
                        vertical: 20,
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
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  "To: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.colleague.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    widget.colleague.designation,
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          NeomorphicTextFormField(
                            inputType: TextInputType.multiline,
                            hintText: "Your Message",
                            numOfMaxLines: 10,
                            onChangeFunction: (String val) {
                              msg = val;
                            },
                          ),
                          SizedBox(height: 10),
                          WideFilledButton(
                              buttonText: "Send",
                              onTapFunction: () async {
                                if (msg != null && msg.isNotEmpty) {
                                  try {
                                    final response = await _apiService.sendMessage({
                                      "SenderId": _currentUser.userID,
                                      "ReceiverId": widget.colleague.iD,
                                      "Message": msg
                                    });
                                    if (response.statusCode == 200) {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: "Message has been sent successfully!",
                                        fillColor: Colors.green,
                                      );
                                    } else {
                                      showSnackBarMessage(
                                        scaffoldKey: _scaffoldKey,
                                        message: "Failed to send message.",
                                        fillColor: Colors.red,
                                      );
                                    }
                                  } catch (ex) {
                                    showSnackBarMessage(
                                      scaffoldKey: _scaffoldKey,
                                      message: ex.toString(),
                                      fillColor: Colors.red,
                                    );
                                  }
                                } else {
                                  showSnackBarMessage(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Please type a message.",
                                    fillColor: Colors.red,
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }
}
