import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/data/models/user_profile.dart';
import 'package:recom_app/services/google-auth-service.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart' as validator;
import '../widgets/wide_filled_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  AppUpdateInfo _updateInfo;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      if(_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable){
        try{InAppUpdate.performImmediateUpdate();}
        catch(e){
          print(e.toString());
          showSnack("Failed to Search Update Version.");
        }
      }
    }).catchError((e) {
      print(e.toString());
      showSnack("Failed to Search Update Version.");
    });
  }
  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      showSnackBarMessage(
        scaffoldKey: _scaffoldKey,
        message: text,
        fillColor: Colors.red,
      );
      // ScaffoldMessenger.of(_scaffoldKey.currentContext)
      //     .showSnackBar(SnackBar(content: Text(text),backgroundColor: Colors.red,));
    }
  }

  // Page Keys
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Form Value Holders
  String _email;
  String _password;
  String _device_id;

  // Password Visibility Controller
  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    Size kScreenSize = MediaQuery.of(context).size;
    //print(kScreenSize.toString());
    return Scaffold(
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/form_bg_logo.png'),
                alignment: Alignment(
                  20 * kScreenSize.width / 1080,
                  25 * kScreenSize.height / 1920,
                ),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Image.asset('assets/images/talent-x.png',fit: BoxFit.contain,width: 200,)
                  //   ],
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 75),
                  //   child: Text(
                  //     "Hey there!",
                  //     style: TextStyle(
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 35,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  // Subtitle Text
                  Padding(
                      padding:  EdgeInsets.only(top: 500 * kScreenSize.height / 1920), //200
                      child: Image.asset('assets/images/talent-x.png',fit: BoxFit.contain,width: 200,)
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Text(
                  //     "It’s time to rock n role!\n Let’s get started now.",
                  //     style: TextStyle(
                  //       color: Color.fromARGB(0xff, 0x90, 0x97, 0xa5),
                  //       fontSize: 18,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),

                  SizedBox(height: 30),
                  //SignIn Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: kFormInputFieldDecoration.copyWith(
                            hintText: "Username",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          // INFO: validate not empty instead of email because currently input username
                          validator: validator.validateNotEmpty,
                          onSaved: (newEmail) => _email = newEmail,
                          //initialValue: 'subrata@shopf.co',
                        ),
                        SizedBox(height: 20),
                        TextFormField(
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
                          validator: validator.validateNotEmpty,
                          onSaved: (newPassword) => _password = newPassword,
                          //initialValue:'12345678',
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () => Navigator.of(context).pushReplacementNamed(FORGOT_PASSWORD_PAGE),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Color.fromARGB(0xaa, 0, 0, 0),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Reset here",
                                style: TextStyle(
                                  color: Color.fromARGB(0xaa, 0, 0, 0),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        _isLoading ? Center(child: CircularProgressIndicator(),)
                            : WideFilledButton(
                          buttonText: "Sign In",
                          onTapFunction: () async {
                            FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
                            String fcmToken = await _firebaseMessaging.getToken();
                            print('fcmToken: ' + fcmToken.toString());
                            _device_id=fcmToken;

                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                User user = await Provider.of<ApiService>(
                                  context,
                                  listen: false,
                                ).signInUser(_getFormData());

                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).updateUser(user);

                                UserProfile userProfile =  await Provider.of<ApiService>(
                                  context,
                                  listen: false,
                                ).getUserProfile();

                                final _prefs = await SharedPreferences.getInstance();
                                await _prefs.setString(
                                  SHARED_PREF_RECOM_USER_KEY,
                                  json.encode(user.toJson()),
                                );

                                // print("-------Rakib------");
                                 print(json.encode(user.toJson()).toString());
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  HOME_PAGE,
                                      (_) => false,
                                );
                              }
                              else {_isLoading = false;}
                            } catch (err) {
                              print("------ SignIn Error -------");
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
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Or Continue with",
                              style: TextStyle(
                                color: Color.fromARGB(0xaa, 0, 0, 0),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        InkWell(
                        onTap: () async {
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await GoogleAuthService().signOut();
                            var credential = await GoogleAuthService().signInWithGoogle();

                            // await firebase.FirebaseAuth.instance.signInWithCredential(credential);
                            // var gUser = firebase.FirebaseAuth.instance.currentUser;

                            User user = await Provider.of<ApiService>(
                              context,
                              listen: false,
                            ).signInUserWithSocialProvider({
                              "provider" : "google",
                              "access_token" : credential.accessToken,
                            });

                            Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).updateUser(user);

                            final _prefs = await SharedPreferences.getInstance();
                            await _prefs.setString(
                              SHARED_PREF_RECOM_USER_KEY,
                              json.encode(user.toJson()),
                            );

                            // print("-------Rakib------");
                            print(json.encode(user.toJson()).toString());
                            _isLoading = false;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              HOME_PAGE,
                                  (_) => false,
                            );

                          } catch (err) {
                            setState(() {
                              _isLoading = false;
                            });
                            print("------ SignIn Error -------");
                            print(err);
                            showSnackBarMessage(
                              scaffoldKey: _scaffoldKey,
                              message: err.message ?? err.toString(),
                              fillColor: Colors.red,
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:  Colors.redAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.google, color: Colors.white,size: 20,),
                              SizedBox(width: 8,),
                              Text('Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:  Colors.white,
                                ),),
                            ],
                          )
                        ),
                       ),
                        //SizedBox(height: 10,),
                        // WideFilledButton(
                        //   buttonText: "Google",
                        //   fillColor: Colors.grey, // Color.fromRGBO(221,75,57,1),
                        //   textColor: Colors.white,
                        //   onTapFunction: () async {
                        //     try {
                        //       setState(() {
                        //         _isLoading = true;
                        //       });
                        //        await GoogleAuthService().signOut();
                        //        var credential = await GoogleAuthService().signInWithGoogle();
                        //
                        //        // await firebase.FirebaseAuth.instance.signInWithCredential(credential);
                        //        // var gUser = firebase.FirebaseAuth.instance.currentUser;
                        //
                        //         User user = await Provider.of<ApiService>(
                        //           context,
                        //           listen: false,
                        //         ).signInUserWithSocialProvider({
                        //           "provider" : "google",
                        //           "access_token" : credential.accessToken,
                        //         });
                        //
                        //         Provider.of<UserProvider>(
                        //           context,
                        //           listen: false,
                        //         ).updateUser(user);
                        //
                        //         final _prefs = await SharedPreferences.getInstance();
                        //         await _prefs.setString(
                        //           SHARED_PREF_RECOM_USER_KEY,
                        //           json.encode(user.toJson()),
                        //         );
                        //
                        //         // print("-------Rakib------");
                        //         print(json.encode(user.toJson()).toString());
                        //       _isLoading = false;
                        //         Navigator.of(context).pushNamedAndRemoveUntil(
                        //           HOME_PAGE,
                        //               (_) => false,
                        //         );
                        //
                        //     } catch (err) {
                        //       setState(() {
                        //         _isLoading = false;
                        //       });
                        //       print("------ SignIn Error -------");
                        //       print(err);
                        //       showSnackBarMessage(
                        //         scaffoldKey: _scaffoldKey,
                        //         message: err.message ?? err.toString(),
                        //         fillColor: Colors.red,
                        //       );
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, String> _getFormData() {
    return {
      "username": _email,
      "password": _password,
      "device_id":_device_id
    };
  }
}
