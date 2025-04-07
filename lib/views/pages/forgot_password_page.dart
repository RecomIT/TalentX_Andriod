import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/views/pages/reset_password_page.dart';

import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart' as validator;
import '../widgets/wide_filled_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Page Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Form Value Holders
  String _email;
  String _resetEmail;
  String _resetOTP;

  var _text = TextEditingController();
  bool _validate = false;
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size kScreenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/form_bg_logo.png'),
                alignment: Alignment(
                  20 * kScreenSize.width / 1080,
                  20 * kScreenSize.height / 1920,
                ),
              ),
            ),
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Title Text
                Padding(
                  padding:  EdgeInsets.only(top: 500 * kScreenSize.height / 1920), //65
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Subtitle Text
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "We'll Send You An E-mail Shortly with OTP",
                    style: TextStyle(
                      color: Color.fromARGB(0xff, 0x90, 0x97, 0xa5),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                //Forgot Password Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: kFormInputFieldDecoration.copyWith(
                          hintText: "Insert Username or E-mail",
                        ),
                        //initialValue: 'recom@hrmisbd.com',
                        keyboardType: TextInputType.text,
                        //validator: validator.validateEmail,
                        onSaved: (newEmail) => _email = newEmail,
                      ),
                      SizedBox(height: 20),
                      WideFilledButton(
                        buttonText: "Submit",
                        onTapFunction: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final response = await Provider.of<ApiService>(
                                context,
                                listen: false,
                              ).forgotPassword(_email);

                              if (response.statusCode == 200) {
                                _formKey.currentState.reset();
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Forget Password request successful.",
                                  fillColor: Colors.green,
                                );
                                Future.delayed(const Duration(milliseconds: 2000), () {
                                  _resetEmail =response.data['data']['email'].toString();
                                  _resetOTP = response.data['data']['random_number'].toString();

                                  print('------------------OTP is '+ _resetOTP);
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            contentPadding: EdgeInsets.only(
                                                left: 25, right: 25),
                                            title: Container(
                                              decoration: new BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                          vertical: 20.0,
                                                          horizontal: 0.0),
                                                      child: Text(
                                                        "OTP Confirmation",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      )),
                                                  InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 14,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.grey[400],
                                                      ),
                                                      backgroundColor: Colors
                                                          .grey[100],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0))),
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize
                                                    .min,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .stretch,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text('Submit a six digit OTP that has been sent to your email'),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: _text,
                                                    minLines: 1,
                                                    style: TextStyle(fontSize: 14),
                                                    decoration:  InputDecoration(
                                                      labelText: 'OTP*',
                                                      labelStyle: TextStyle(fontSize: 12),
                                                      errorText: !_validate ? 'This field is required' : null,
                                                      //border: OutlineInputBorder()
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                    _text.text.isEmpty
                                                        ? _validate = false
                                                        : _validate = true;
                                                    setState(() {
                                                      _validate;
                                                    });
                                                    if (_validate) {
                                                      if (_resetOTP ==
                                                          _text.text) {
                                                        showSnackBarMessage(
                                                          scaffoldKey:
                                                              _scaffoldKey,
                                                          message:
                                                              "OTP Matched.",
                                                          fillColor:
                                                              Colors.green,
                                                        );
                                                        setState(() {
                                                          _text =
                                                              TextEditingController();
                                                          _validate = false;
                                                        });
                                                        Future.delayed(const Duration(milliseconds: 2000), (){
                                                          Navigator.of(context).pushReplacementNamed(RESET_PASSWORD_PAGE,arguments: _email);
                                                        });


                                                         //RESET_PASSWORD_PAGE
                                                      } else {
                                                        showSnackBarMessage(
                                                          scaffoldKey:
                                                              _scaffoldKey,
                                                          message:
                                                              "Invalid OTP or Expired.",
                                                          fillColor: Colors.red,
                                                        );

                                                        Navigator.pop(context);
                                                        setState(() {
                                                          _text =
                                                              TextEditingController();
                                                          _validate = false;
                                                        });
                                                      }
                                                    }
                                                  }),
                                            ],
                                          ));
                                });

                                //Navigator.of(context).pushReplacementNamed(SIGN_IN_PAGE});
                              } else {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: response.data["message"],
                                  fillColor: Colors.red,
                                );
                              }
                            }
                          } catch (err) {
                            print("------ Forgot Password Error -------");
                            print(err);
                            showSnackBarMessage(
                              scaffoldKey: _scaffoldKey,
                              message: err.message ?? err.toString(),
                              fillColor: Colors.red,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed(SIGN_IN_PAGE),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remembered Password?",
                        style: TextStyle(color: Color.fromARGB(0xaa, 0, 0, 0)),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Sign In",
                        style: TextStyle(color: Color.fromARGB(0xaa, 0, 0, 0),
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // AlertDialog resetPasswordDialog(BuildContext context) {
  //   return AlertDialog(
  //     contentPadding: EdgeInsets.only(left: 25, right: 25),
  //     title: Container(
  //       decoration: new BoxDecoration(
  //         color: kPrimaryColor,
  //         borderRadius: BorderRadius.all(Radius.circular(10)),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Container(
  //               padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
  //               child: Text(
  //                 "OTP Confirmation",
  //                 style: TextStyle(color: Colors.white),
  //               )),
  //           InkResponse(
  //             onTap: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: CircleAvatar(
  //               radius: 14,
  //               child: Icon(
  //                 Icons.close,
  //                 color: Colors.grey[400],
  //               ),
  //               backgroundColor: Colors.grey[100],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //     content: Container(
  //       child: SingleChildScrollView(
  //         child: Form(
  //           key: _formKey,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: <Widget>[
  //               SizedBox(
  //                 height: 0,
  //               ),
  //               TextFormField(
  //                 minLines: 1,
  //                 style: TextStyle(fontSize: 14),
  //                 decoration: const InputDecoration(
  //                   labelText: 'OTP*',
  //                   labelStyle: TextStyle(fontSize: 12),
  //                   hintText: 'A six digit number has been sent on your email',
  //                   //border: OutlineInputBorder()
  //                 ),
  //                 onSaved: (String val) {
  //                   setState(() {
  //                     //updateProfileInfo.presentAddress = val;
  //                   });
  //
  //                   // This optional block of code can be used to run
  //                   // code when the user saves the form.
  //                 },
  //                 validator: (String value) {
  //                   return (value == null || value.isEmpty
  //                       ? '*This field is Required'
  //                       : null);
  //                 },
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     actions: <Widget>[
  //       // RaisedButton(
  //       //   shape: RoundedRectangleBorder(
  //       //     borderRadius: BorderRadius.all(Radius.circular(10)),
  //       //   ),
  //       //   child: Text(
  //       //     "Update",
  //       //     style: TextStyle(
  //       //       color: Colors.white,
  //       //       fontWeight: FontWeight.bold,
  //       //     ),
  //       //   ),
  //       //   onPressed: () async {
  //       //     if (_formKey.currentState.validate()) {
  //       //       _formKey.currentState.save();
  //       //       try {
  //       //         final response = await _apiService
  //       //             .updateProfileInfo(updateProfileInfo.toJson());
  //       //         if (response.statusCode == 200) {
  //       //           _formKey.currentState.reset();
  //       //           showSnackBarMessage(
  //       //             scaffoldKey: _scaffoldKey,
  //       //             message: "Profile Info Updated Successfully.",
  //       //             fillColor: Colors.green,
  //       //           );
  //       //           Navigator.pop(context); // pop current page
  //       //           if (pageScreen != ProfilePageScreen.BasicInfo) {
  //       //             setState(() {
  //       //               pageScreen = ProfilePageScreen.BasicInfo;
  //       //             });
  //       //           }
  //       //         } else {
  //       //           showSnackBarMessage(
  //       //             scaffoldKey: _scaffoldKey,
  //       //             message: response.data["message"],
  //       //             fillColor: Colors.red,
  //       //           );
  //       //         }
  //       //       } catch (ex) {
  //       //         showSnackBarMessage(
  //       //           scaffoldKey: _scaffoldKey,
  //       //           message: "Failed to Update Profile Info.",
  //       //           fillColor: Colors.red,
  //       //         );
  //       //       }
  //       //     }
  //       //   },
  //       // ),
  //     ],
  //   );
  // }
}
