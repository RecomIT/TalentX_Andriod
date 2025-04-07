import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart' as validator;
import '../widgets/wide_filled_button.dart';

class ResetPasswordPage extends StatefulWidget {
final String email;
ResetPasswordPage({Key key, @required this.email}) : super(key: key);
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  // Password Visibility Controller
  bool _hidePassword = true;
  bool _isLoading = false;
  // Page Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  String _resetEmail;
  String _password;
  @override

  Widget build(BuildContext context) {
    Size kScreenSize = MediaQuery
        .of(context)
        .size;
    _resetEmail=widget.email;
    //print('-------------Email--------------'  + widget.email);
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
                  padding: const EdgeInsets.only(top: 65),
                  child: Text(
                    "Reset Password",
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
                    "Please Reset Your Password",
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
                          hintText: "E-mail",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // INFO: validate not empty instead of email because currently input username
                        validator: (val) {
                          if (val.isEmpty) return 'This field is required.';
                          return null;
                        },
                        //onSaved: (newEmail) => _email = newEmail,
                        initialValue: _resetEmail,
                        onSaved: (val) => _resetEmail = val,
                        readOnly: true,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _pass,
                        decoration: kFormInputFieldDecoration.copyWith(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                            icon: _hidePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                        validator: (val) {
                          if (val.isEmpty) return '*This field is required';
                          return null;
                        },
                        onSaved: (newPassword) => _password = newPassword,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPass,
                        decoration: kFormInputFieldDecoration.copyWith(
                          hintText: "Confirm Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                            icon: _hidePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _hidePassword,
                          validator: (val){
                            if(val.isEmpty)
                              return '*This field is required';
                            if(val != _pass.text)
                              return 'Passwords Not Matched';
                            return null;
                          },
                      ),
                      SizedBox(height: 20),
                      _isLoading ? Center(child: CircularProgressIndicator(),)
                          : WideFilledButton(
                        buttonText: "Update",
                        onTapFunction: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              final formDate= {"email":_resetEmail,"password":_password};
                              final response = await Provider.of<ApiService>(
                                context,
                                listen: false,
                              ).resetPassword(formDate);

                              if (response.statusCode == 200) {
                                _formKey.currentState.reset();
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: "Password reset successful.",
                                  fillColor: Colors.green,
                                );

                                Future.delayed(const Duration(milliseconds: 2000), (){
                                  Navigator.of(context).pushReplacementNamed(SIGN_IN_PAGE);
                                });

                              } else {
                                showSnackBarMessage(
                                  scaffoldKey: _scaffoldKey,
                                  message: response.data["message"],
                                  fillColor: Colors.red,
                                );
                              }
                              setState(() {
                                _isLoading = false;
                              });
                            }
                            else {_isLoading = false;}
                          } catch (err) {
                            print("------  Error -------");
                            print(err);
                            setState(() {
                              _isLoading = false;
                            });
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
              ],
            ),
          ),
        ),
      ),
    );
  }

}
