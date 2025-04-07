import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:recom_app/services/navigation/routing_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_profile.dart';
import '../../services/api/api.dart';
import '../../utils/constants.dart';
import '../widgets/neomorphic_text_form_field.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/small_selectable_svg_button.dart';
import "../../services/helper/string_extension.dart";

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _contactInfoFormKey = GlobalKey<FormState>();
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  ApiService _apiService;

  ProfilePageScreen pageScreen = ProfilePageScreen.BasicInfo;
  bool editMode = false;

  BasicInfo userBasicInfo;
  ContactInfo userContactInfo;
  PersonalInfo userPersonalInfo;
  UpdateProfileInfo updateProfileInfo;

  String dp;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return  buildProfileScaffold();
  }

  Scaffold buildProfileScaffold()  {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
      child: SingleChildScrollView(
        child: FutureBuilder<UserProfile>(
            future: _apiService.getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                userBasicInfo = snapshot.data.basicInfo;
                userContactInfo = snapshot.data.contactInfo;
                userPersonalInfo = snapshot.data.personalInfo;
                //print(userBasicInfo.supervisor.toString());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 215,
                      width: double.infinity,
                      color: kPrimaryColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: IconButton(
                          //     icon: Icon(
                          //       Icons.arrow_back_ios,
                          //       color: Colors.white,
                          //     ),
                          //     onPressed: () => Navigator.of(context).pop(),
                          //   ),
                          // ),
                          SizedBox(
                            width: 115,
                            height: 115,
                            child: Stack(
                              children: [
                                Container(
                                  width: 115,
                                  height: 115,
                                  padding: EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(55)),
                                    color: Colors.white,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(55)),
                                      image: DecorationImage(
                                        image: MemoryImage(base64Decode(dp ?? snapshot.data.photo)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(1.5, -0.85),
                                  child: IconButton(
                                    icon: Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: kSecondaryColor,
                                        size: 17,
                                      ),
                                    ),
                                    onPressed: () async {
                                      return;
                                      var status = await Permission.storage.status;
                                      if (!status.isGranted) {
                                        status = await Permission.storage.request();
                                        if (!status.isGranted) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Please allow storage permission!",
                                            fillColor: Colors.red,
                                          );
                                          return;
                                        }
                                      }
                                      final pickedFile = await FilePicker.getFile(
                                        type: FileType.custom,
                                        allowedExtensions: ["jpeg", "jpg", "png"],
                                      );
                                      if (pickedFile == null) return;
                                      final fileCotent = base64Encode(pickedFile.readAsBytesSync());
                                      //{"profile_photo": fileCotent}

                                      try {
                                        FormData formData = FormData.fromMap({
                                          "profile_photo":await MultipartFile.fromFile( pickedFile.path,  filename: pickedFile.path.split('/').last,),
                                        });

                                        final response = await _apiService.updateProfilePhoto(formData);
                                        if (response.statusCode == 200) {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: "Successfully updated profile photo!",
                                            fillColor: Colors.green,
                                          );
                                          setState(() {
                                            dp = fileCotent;
                                          });
                                        } else {
                                          showSnackBarMessage(
                                            scaffoldKey: _scaffoldKey,
                                            message: response.data["message"],
                                            fillColor: Colors.red,
                                          );
                                        }
                                      } catch (ex) {
                                        showSnackBarMessage(
                                          scaffoldKey: _scaffoldKey,
                                          message: "Failed to update profile photo!",
                                          fillColor: Colors.red,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),

                          Text(
                            userBasicInfo.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            userBasicInfo.employeeRoleName == 'N/A' ? '' : userBasicInfo.employeeRoleName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SmallSelectabelSvgIconButton(
                            text: "Basic Info",
                            svgFile: "assets/icons/basic_info.svg",
                            isSelected: pageScreen == ProfilePageScreen.BasicInfo,
                            onTapFunction: () {
                              if (pageScreen != ProfilePageScreen.BasicInfo) {
                                setState(() {
                                  editMode = false;
                                  pageScreen = ProfilePageScreen.BasicInfo;
                                });
                              }
                            },
                          ),
                          SmallSelectabelSvgIconButton(
                            text: "Contact Info",
                            svgFile: "assets/icons/contact_info.svg",
                            isSelected: pageScreen == ProfilePageScreen.ContactInfo,
                            onTapFunction: () {
                              if (pageScreen != ProfilePageScreen.ContactInfo) {
                                setState(() {
                                  editMode = false;
                                  pageScreen = ProfilePageScreen.ContactInfo;
                                });
                              }
                            },
                          ),
                          SmallSelectabelSvgIconButton(
                            text: "Personal Info",
                            svgFile: "assets/icons/personal_info.svg",
                            isSelected: pageScreen == ProfilePageScreen.PersonalInfo,
                            onTapFunction: () {
                              if (pageScreen != ProfilePageScreen.PersonalInfo) {
                                setState(() {
                                  editMode = false;
                                  pageScreen = ProfilePageScreen.PersonalInfo;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    getProfileScreen(pageScreen),
                    SizedBox(height: 50),
                  ],
                );
              } else if (snapshot.hasError) {
                return SizedBox();
              }
              return SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
      ),
    ),
    bottomNavigationBar: RoundedBottomNavBar(
      activeIndex: 3,
    ),
  );
  }

  Widget getProfileScreen(ProfilePageScreen pageScreen) {
    if (pageScreen == ProfilePageScreen.BasicInfo) {
      return Form(
        key: _basicInfoFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Name",
                  initVal: 'Name : ${userBasicInfo.name}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.name = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Role",
                  initVal: 'Role : ${userBasicInfo.employeeRoleName}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.employeeRoleName = val;
                  }),

              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Short Name",
              //     initVal: 'Short Name : ${userBasicInfo.shortName}',
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.shortName = val;
              //     }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Code",
                  initVal: 'Code : ${userBasicInfo.code}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.code = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Designation",
                  initVal: 'Designation : ${userBasicInfo.designation}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.designation = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Department",
                  initVal: 'Department : ${userBasicInfo.department}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.department = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Division",
                  initVal: 'Division : ${userBasicInfo.division}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.designation = val;
                  }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Category",
              //     initVal: 'Category : ${userBasicInfo.jobLevel}',
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.jobLevel = val;
              //     }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Grade",
                  initVal: 'Grade : ${userBasicInfo.grade}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.grade = val;
                  }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Sub-Department",
              //     initVal: userBasicInfo.subDepartment,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.subDepartment = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "SSub-Department",
              //     initVal: userBasicInfo.sSubDepartment,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.sSubDepartment = val;
              //     }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Location",
                  initVal: 'Location : ${userBasicInfo.workLocation}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.workLocation = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Supervisor",
                  initVal: 'Supervisor : ${userBasicInfo.supervisor}',
                  isReadOnly: true,
                  onChangeFunction: (String val) {
                    userBasicInfo.supervisor = val;
                  }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Manager",
              //     initVal: userBasicInfo.manager,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.manager = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Head of Department",
              //     initVal: userBasicInfo.headofDepartment,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.headofDepartment = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Lead Management",
              //     initVal: userBasicInfo.leadManagement,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.leadManagement = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "HR Authority",
              //     initVal: userBasicInfo.hRAuthority,
              //     isReadOnly: true,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.hRAuthority = val;
              //     }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Date of Joining",
                  initVal: 'Date of Joining : ${userBasicInfo.dateofJoining}',
                  isReadOnly: !editMode,
                  onChangeFunction: (String val) {
                    userBasicInfo.dateofJoining = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Date of Confirmation",
                  initVal: 'Date of Confirmation : ${userBasicInfo.dateofConfirmation}',
                  isReadOnly: !editMode,
                  onChangeFunction: (String val) {
                    userBasicInfo.dateofConfirmation = val;
                  }),
              NeomorphicTextFormField(
                  inputType: TextInputType.text,
                  hintText: "Date of Birth",
                  initVal: 'Date of Birth : ${userBasicInfo.dateOfBirth}',
                  isReadOnly: !editMode,
                  onChangeFunction: (String val) {
                    userBasicInfo.dateOfBirth = val;
                  }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Finger Id",
              //     initVal: userBasicInfo.fingerId,
              //     isReadOnly: !editMode,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.fingerId = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Ref Id",
              //     initVal: userBasicInfo.refId,
              //     isReadOnly: !editMode,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.refId = val;
              //     }),
              // NeomorphicTextFormField(
              //     inputType: TextInputType.text,
              //     hintText: "Date of Seperation",
              //     initVal: 'Date of Resignation : ${userBasicInfo.dateofSeperation}',
              //     isReadOnly: !editMode,
              //     onChangeFunction: (String val) {
              //       userBasicInfo.dateofSeperation = val;
              //     }),
              SizedBox(height: 15),
              // Row(
              //   children: [
              //     Expanded(
              //       child: RaisedButton(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Text(
              //           "Edit",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //
              //         onPressed: () {
              //           // setState(() {
              //           //   editMode = true;
              //           // });
              //           // showSnackBarMessage(
              //           //   scaffoldKey: _scaffoldKey,
              //           //   message: "Set to Edit Mode",
              //           //   fillColor: Colors.blue,
              //           // );
              //           updateProfileInfo = new UpdateProfileInfo();
              //           showDialog(
              //               barrierDismissible: false,
              //               context: context,
              //               builder: (BuildContext context) => updateProfileDialog(context));
              //         },
              //         // onPressed: () {
              //         //   setState(() {
              //         //     editMode = true;
              //         //   });
              //         //   showSnackBarMessage(
              //         //     scaffoldKey: _scaffoldKey,
              //         //     message: "Set to Edit Mode",
              //         //     fillColor: Colors.blue,
              //         //   );
              //         // },
              //       ),
              //     ),
              //     // Expanded(
              //     //   child: RaisedButton(
              //     //     shape: RoundedRectangleBorder(
              //     //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     //     ),
              //     //     child: Text(
              //     //       "Save",
              //     //       style: TextStyle(
              //     //         color: Colors.white,
              //     //         fontWeight: FontWeight.bold,
              //     //       ),
              //     //     ),
              //     //     onPressed: () async {
              //     //       if (!editMode) return;
              //     //       setState(() {
              //     //         editMode = false;
              //     //       });
              //     //       try {
              //     //         final response = await _apiService.updateProfileBasicInfo(userBasicInfo.toJson());
              //     //         if (response.statusCode == 200) {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: "Basic Info Updated.",
              //     //             fillColor: Colors.green,
              //     //           );
              //     //         } else {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: response.data["message"],
              //     //             fillColor: Colors.red,
              //     //           );
              //     //         }
              //     //       } catch (ex) {
              //     //         showSnackBarMessage(
              //     //           scaffoldKey: _scaffoldKey,
              //     //           message: "Failed to Update Basic Info.",
              //     //           fillColor: Colors.red,
              //     //         );
              //     //       }
              //     //     },
              //     //   ),
              //     // ),
              //   ],
              // ),
              // SizedBox(height: 15),
            ],
          ),
        ),
      );
    } else if (pageScreen == ProfilePageScreen.ContactInfo) {
      return Form(
        key: _contactInfoFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Official Email : ${userContactInfo.officialEmail}',
                hintText: "Official Email",
                onChangeFunction: (String val) {
                  userContactInfo.officialEmail = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Personal Email : ${userContactInfo.personalEmail}',
                hintText: "Personal Email",
                onChangeFunction: (String val) {
                  userContactInfo.personalEmail = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Official Phone No : ${userContactInfo.officialPhoneNo}',
                hintText: "Official Phone No",
                onChangeFunction: (String val) {
                  userContactInfo.officialPhoneNo = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Personal Phone No : ${userContactInfo.personalPhoneNo}',
                hintText: "Personal Phone No",
                onChangeFunction: (String val) {
                  userContactInfo.personalPhoneNo = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Present Address : ${userContactInfo.presentAddress}',
                hintText: "Present Address",
                numOfMaxLines: 4,
                onChangeFunction: (String val) {
                  userContactInfo.presentAddress = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Permanent Address : ${userContactInfo.permanentAddress}',
                hintText: "Permanent Address",
                numOfMaxLines: 4,
                onChangeFunction: (String val) {
                  userContactInfo.permanentAddress = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Emergency Contact Person : ${userContactInfo.emergencyContactPerson}',
                hintText: "Emergency Contact Person",
                onChangeFunction: (String val) {
                  userContactInfo.emergencyContactPerson = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Emergency Contact Relation : ${userContactInfo.emergencyContactRelation}',
                hintText: "Emergency Contact Relation",
                onChangeFunction: (String val) {
                  userContactInfo.emergencyContactRelation = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Emergency Contact Number : ${userContactInfo.emergencyContactNumber}',
                hintText: "Emergency Contact Number",
                onChangeFunction: (String val) {
                  userContactInfo.emergencyContactNumber = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: 'Emergency Contact Address : ${userContactInfo.emergencyContactAddress}',
                hintText: "Emergency Contact Address",
                numOfMaxLines: 4,
                onChangeFunction: (String val) {
                  userContactInfo.emergencyContactAddress = val;
                },
              ),

              SizedBox(height: 15),
              // Row(
              //   children: [
              //     Expanded(
              //       child: RaisedButton(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Text(
              //           "Edit",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //
              //         onPressed: () {
              //           // setState(() {
              //           //   editMode = true;
              //           // });
              //           // showSnackBarMessage(
              //           //   scaffoldKey: _scaffoldKey,
              //           //   message: "Set to Edit Mode",
              //           //   fillColor: Colors.blue,
              //           // );
              //           updateProfileInfo = new UpdateProfileInfo();
              //           showDialog(
              //               barrierDismissible: false,
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return   updateProfileDialog(context);
              //               });
              //         },
              //       ),
              //     ),
              //     SizedBox(height: 15),
              //     // Expanded(
              //     //   child: RaisedButton(
              //     //     shape: RoundedRectangleBorder(
              //     //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     //     ),
              //     //     child: Text(
              //     //       "Save",
              //     //       style: TextStyle(
              //     //         color: Colors.white,
              //     //         fontWeight: FontWeight.bold,
              //     //       ),
              //     //     ),
              //     //     onPressed: () async {
              //     //       if (!editMode) return;
              //     //       setState(() {
              //     //         editMode = false;
              //     //       });
              //     //       try {
              //     //         final response = await _apiService.updateProfileContactInfo(userContactInfo.toJson());
              //     //         if (response.statusCode == 200) {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: "Contact Info Updated.",
              //     //             fillColor: Colors.green,
              //     //           );
              //     //         } else {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: response.data["message"],
              //     //             fillColor: Colors.red,
              //     //           );
              //     //         }
              //     //       } catch (ex) {
              //     //         showSnackBarMessage(
              //     //           scaffoldKey: _scaffoldKey,
              //     //           message: "Failed to Update Contact Info.",
              //     //           fillColor: Colors.red,
              //     //         );
              //     //       }
              //     //     },
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    } else if (pageScreen == ProfilePageScreen.PersonalInfo) {
      return Form(
        key: _personalInfoFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Father's Name : ${userPersonalInfo.fathersName}",
                hintText: "Father's Name",
                onChangeFunction: (String val) {
                  userPersonalInfo.fathersName = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Mother's Name : ${userPersonalInfo.mothersName}",
                hintText: "Mother's Name",
                onChangeFunction: (String val) {
                  userPersonalInfo.mothersName = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Gender : ${userPersonalInfo.gender.capitalize()}",
                hintText: "Gender",
                onChangeFunction: (String val) {
                  userPersonalInfo.gender = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Blood Group : ${userPersonalInfo.bloodGroup}",
                hintText: "Blood Group",
                onChangeFunction: (String val) {
                  userPersonalInfo.bloodGroup = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Marital Status : ${userPersonalInfo.maritalstatus.capitalize()}",
                hintText: "Marital Status",
                onChangeFunction: (String val) {
                  userPersonalInfo.maritalstatus = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Religion : ${userPersonalInfo.religion.capitalize()}",
                hintText: "Religion",
                onChangeFunction: (String val) {
                  userPersonalInfo.religion = val;
                },
              ),
              // NeomorphicTextFormField(
              //   inputType: TextInputType.text,
              //   isReadOnly: !editMode,
              //   initVal: "Bank A/C No : ${userPersonalInfo.bankACNo}",
              //   hintText: "Bank A/C No",
              //   onChangeFunction: (String val) {
              //     userPersonalInfo.bankACNo = val;
              //   },
              // ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "NID/Passport No : ${userPersonalInfo.nIDPassportNo}",
                hintText: "NID/Passport No",
                onChangeFunction: (String val) {
                  userPersonalInfo.nIDPassportNo = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Driving License No : ${userPersonalInfo.drivingLicenseNumber}",
                hintText: "Driving License No",
                onChangeFunction: (String val) {
                  userPersonalInfo.drivingLicenseNumber = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "TIN No : ${userPersonalInfo.tinNo}",
                hintText: "TIN No",
                onChangeFunction: (String val) {
                  userPersonalInfo.tinNo = val;
                },
              ),
              NeomorphicTextFormField(
                inputType: TextInputType.text,
                isReadOnly: !editMode,
                initVal: "Nationality : ${userPersonalInfo.nationality}",
                hintText: "Nationality",
                onChangeFunction: (String val) {
                  userPersonalInfo.nationality = val;
                },
              ),
              SizedBox(height: 15),
              // Row(
              //   children: [
              //     Expanded(
              //       child: RaisedButton(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //         ),
              //         child: Text(
              //           "Edit",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         onPressed: () {
              //           updateProfileInfo = new UpdateProfileInfo();
              //           showDialog(
              //               barrierDismissible: false,
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return   updateProfileDialog(context);
              //               });
              //         },
              //       ),
              //     ),
              //     SizedBox(height: 15),
              //     // Expanded(
              //     //   child: RaisedButton(
              //     //     shape: RoundedRectangleBorder(
              //     //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //     //     ),
              //     //     child: Text(
              //     //       "Save",
              //     //       style: TextStyle(
              //     //         color: Colors.white,
              //     //         fontWeight: FontWeight.bold,
              //     //       ),
              //     //     ),
              //     //     onPressed: () async {
              //     //       if (!editMode) return;
              //     //       setState(() {
              //     //         editMode = false;
              //     //       });
              //     //       try {
              //     //         final response = await _apiService.updateProfilePersonalInfo(userPersonalInfo.toJson());
              //     //         if (response.statusCode == 200) {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: "Personal Info Updated.",
              //     //             fillColor: Colors.green,
              //     //           );
              //     //         } else {
              //     //           showSnackBarMessage(
              //     //             scaffoldKey: _scaffoldKey,
              //     //             message: response.data["message"],
              //     //             fillColor: Colors.red,
              //     //           );
              //     //         }
              //     //       } catch (ex) {
              //     //         showSnackBarMessage(
              //     //           scaffoldKey: _scaffoldKey,
              //     //           message: "Failed to Update Personal Info.",
              //     //           fillColor: Colors.red,
              //     //         );
              //     //       }
              //     //     },
              //     //   ),
              //     // ),
              //   ],
              // ),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }

  AlertDialog updateProfileDialog(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25),
      title: Container(
        decoration: new BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                child: Text(
                  "Update Basic Info",
                  style: TextStyle(color: Colors.white),
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
                backgroundColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: 500,
        width: 600,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 2,
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Present Address*',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.presentAddress,
                  onSaved: (String val) {
                    updateProfileInfo.presentAddress = val;
                    // setState(() {
                    //   updateProfileInfo.presentAddress = val;
                    // });

                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return (value == null || value.isEmpty
                        ? '*This field is Required'
                        : null);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 2,
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Permanent Address*',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.permanentAddress,
                  onSaved: (String val) {
                    updateProfileInfo.permanentAddress = val;
                    // setState(() {
                    //   updateProfileInfo.permanentAddress = val;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return (value == null || value.isEmpty
                        ? '*This field is Required'
                        : null);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Personal Phone No.',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.personalPhoneNo,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.personalPhoneNo = value;
                    // setState(() {
                    //   updateProfileInfo.personalPhoneNo = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Personal Email',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.personalEmail,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.personalEmail = value;
                    // setState(() {
                    //   updateProfileInfo.personalEmail = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Name',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.emergencyContactPerson,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.emergencyContactPerson = value;
                    // setState(() {
                    //   updateProfileInfo.emergencyContactPerson = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Relation',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.emergencyContactRelation,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.emergencyContactRelation = value;
                    // setState(() {
                    //   updateProfileInfo.emergencyContactRelation = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Phone',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.emergencyContactNumber,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.emergencyContactNumber = value;
                    // setState(() {
                    //   updateProfileInfo.emergencyContactNumber = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  minLines: 1,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Address',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userContactInfo.emergencyContactAddress,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.emergencyContactAddress = value;
                    // setState(() {
                    //   updateProfileInfo.emergencyContactAddress = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userPersonalInfo.bloodGroup,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.bloodGroup = value;
                    // setState(() {
                    //   updateProfileInfo.bloodGroup = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Driving License',
                    labelStyle: TextStyle(fontSize: 12),
                    //border: OutlineInputBorder()
                  ),
                  initialValue: userPersonalInfo.drivingLicenseNumber,
                  onSaved: (String value) {
                    value = value == null || value.isEmpty ? 'N/A' : value;
                    updateProfileInfo.drivingLicenseNumber = value;
                    // setState(() {
                    //   updateProfileInfo.drivingLicenseNumber = value;
                    // });
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            "Update",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              try {
                final response = await _apiService
                    .updateProfileInfo(updateProfileInfo.toJson());
                if (response.statusCode == 200) {
                  _formKey.currentState.reset();
                  showSnackBarMessage(
                    scaffoldKey: _scaffoldKey,
                    message: "Profile Info Updated Successfully.",
                    fillColor: Colors.green,
                  );
                  Navigator.pop(context); // pop current page
                  if (pageScreen != ProfilePageScreen.BasicInfo) {
                    setState(() {
                      pageScreen = ProfilePageScreen.BasicInfo;
                    });
                  }


                } else {
                  showSnackBarMessage(
                    scaffoldKey: _scaffoldKey,
                    message: response.data["message"],
                    fillColor: Colors.red,
                  );
                }
              } catch (ex) {
                showSnackBarMessage(
                  scaffoldKey: _scaffoldKey,
                  message: "Failed to Update Profile Info.",
                  fillColor: Colors.red,
                );
              }
            }
          },
        ),
      ],
    );
  }
}
