import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/search_colleague_data.dart';
import '../../data/models/user.dart';
import '../../data/providers/UserProvider.dart';
import '../../services/api/api.dart';
import '../../services/navigation/routing_constants.dart';
import '../../utils/constants.dart';
import '../widgets/flat_app_bar.dart';
import '../widgets/rounded_bottom_navbar.dart';
import '../widgets/selectable_svg_icon_button.dart';

class ColleaguesPage extends StatefulWidget {
  @override
  _ColleaguesPageState createState() => _ColleaguesPageState();
}

class _ColleaguesPageState extends State<ColleaguesPage> {
  User _currentUser;
  ApiService _apiService;

  ColleaguesPageScreen pageScreen = ColleaguesPageScreen.SearchColleagues;
  String searchText;
  Future<SearchColleagueData> _searhColleagueList;
  ScrollController _scrollController = ScrollController();
  int _currentMax= 20;
  List<Colleague> _colleagues;
  List<Colleague> _allColleagues;

  @override
  void initState() {
    super.initState();
    _apiService = Provider.of<ApiService>(context, listen: false);
    _searhColleagueList = _apiService.getSearhColleagueList();
    _scrollController.addListener(() {
        if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
          _getMoreList();

        }
    });
  }
  _getMoreList()
  {
    print('Get More List');
    for(int i =_currentMax ; i < _currentMax + 20; i++)
    {
      var item = _allColleagues[_currentMax];
      _colleagues.add(item);
    }
    _currentMax = _currentMax+20;
    setState(() {});
    print('_currentMax ' + _currentMax.toString());
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserProvider>(context, listen: false).user;

    final kScreenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: getFlatAppBar(
        context,
        _currentUser.name,
        _currentUser.role,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: 90,
                    color: kPrimaryColor,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: kScreenSize.width * 0.05,
                    ),
                    width: kScreenSize.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Colleagues",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectabelSvgIconButton(
                                text: "Search Colleagues",
                                svgFile: "assets/icons/colleagues_big.svg",
                                onTapFunction: () {
                                  setState(() {
                                    pageScreen = ColleaguesPageScreen.SearchColleagues;
                                  });
                                },
                                isSelected: pageScreen == ColleaguesPageScreen.SearchColleagues,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              pageScreen == ColleaguesPageScreen.SearchColleagues
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (kScreenSize.width - 60) * 0.8,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    setState(() {
                                      searchText = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(20.0),
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: "Search by Name or Id..",
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.search,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        FutureBuilder<SearchColleagueData>(
                          future: _searhColleagueList,  //_apiService.getSearhColleagueList()
                          builder: (context, snapshot) {
                            if (snapshot.hasData && !snapshot.hasError) {
                              _allColleagues=snapshot.data.colleague.toList();
                              _allColleagues.sort((a, b) => a.name.toLowerCase().trim().compareTo(b.name.toLowerCase().trim()));

                              if(searchText !=null)
                                {
                                  _colleagues = _allColleagues.where((e) => e.name.toLowerCase().contains(searchText.toLowerCase()) ||
                                      e.code.contains(searchText.toLowerCase()) ||
                                      e.email.contains(searchText.toLowerCase()) || e.phoneNo.contains(searchText.toLowerCase())).take(_currentMax).toList();
                                }
                              else{
                                _colleagues = _allColleagues.take(_currentMax).toList();
                              }
                              return Column(
                                children: List.generate(
                                  _colleagues?.length,
                                      (idx) {
                                    return searchText == null || searchText.isEmpty || _colleagues[idx].name.toLowerCase().contains(searchText.toLowerCase())
                                    || _colleagues[idx].code.contains(searchText.toLowerCase())  || _colleagues[idx].email.contains(searchText.toLowerCase())
                                        || _colleagues[idx].phoneNo.contains(searchText.toLowerCase())
                                        ? Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 20,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: (kScreenSize.width - 40) * 0.60,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_colleagues[idx].name} (${_colleagues[idx].code})', //${_colleagues[idx].code}
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                // InkWell(
                                                //   onTap: () async {
                                                //     //print('CLICKED');
                                                //     var url = 'tel://${colleagues[idx].phoneNo}';
                                                //     //await launch('tel://$url');
                                                //     if (await canLaunch(url)) {
                                                //       await launch(url);
                                                //     } else {
                                                //       throw 'Could not launch $url';
                                                //     }
                                                //   },
                                                //   child: Row(
                                                //     children: [
                                                //       Icon(Icons.call,size: 16,),
                                                //       Text(' ' + colleagues[idx].phoneNo)
                                                //     ],
                                                //   ),
                                                // ),
                                                Text(
                                                  '${_colleagues[idx].employee_role_name =='N/A'
                                                      ? '${_colleagues[idx].department}' =='N/A' ? '' :'${_colleagues[idx].department}'
                                                      : '${_colleagues[idx].employee_role_name}'

                                                  }',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  //print('CLICKED');
                                                  var url =
                                                      'tel://${_colleagues[idx].phoneNo}';
                                                  //await launch('tel://$url');
                                                  print(url.toString());
                                                  if (await canLaunch(
                                                      url)) {
                                                    await launch(url);
                                                  } else {
                                                    throw 'Could not launch $url';
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(7),
                                                    ),
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.phone_in_talk_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Call",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                    COLLEAGUE_Detail_PAGE,
                                                    arguments: _colleagues[idx],
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(7),
                                                    ),
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                        Icons.message_outlined,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        "Details",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     InkWell(
                                          //       onTap: () {
                                          //         Navigator.of(context).pushNamed(
                                          //           EMAIL_COLLEAGUE_PAGE,
                                          //           arguments: colleagues[idx],
                                          //         );
                                          //       },
                                          //       child: Container(
                                          //         padding: EdgeInsets.symmetric(
                                          //           horizontal: 15,
                                          //           vertical: 2,
                                          //         ),
                                          //         decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.all(
                                          //             Radius.circular(7),
                                          //           ),
                                          //           color: kPrimaryColor,
                                          //         ),
                                          //         child: Column(
                                          //           children: [
                                          //             Icon(
                                          //               Icons.mail_outline,
                                          //               color: Colors.white,
                                          //             ),
                                          //             Text(
                                          //               "Email",
                                          //               style: TextStyle(
                                          //                 fontWeight: FontWeight.bold,
                                          //                 fontSize: 10,
                                          //                 color: Colors.white,
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     SizedBox(width: 5),
                                          //     InkWell(
                                          //       onTap: () {
                                          //         Navigator.of(context).pushNamed(
                                          //           MSG_COLLEAGUE_PAGE,
                                          //           arguments: colleagues[idx],
                                          //         );
                                          //       },
                                          //       child: Container(
                                          //         padding: EdgeInsets.symmetric(
                                          //           horizontal: 5,
                                          //           vertical: 2,
                                          //         ),
                                          //         decoration: BoxDecoration(
                                          //           borderRadius: BorderRadius.all(
                                          //             Radius.circular(7),
                                          //           ),
                                          //           color: kPrimaryColor,
                                          //         ),
                                          //         child: Column(
                                          //           children: [
                                          //             Icon(
                                          //               Icons.message_outlined,
                                          //               color: Colors.white,
                                          //             ),
                                          //             Text(
                                          //               "Message",
                                          //               style: TextStyle(
                                          //                 fontWeight: FontWeight.bold,
                                          //                 fontSize: 10,
                                          //                 color: Colors.white,
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    )
                                        : SizedBox();
                                  },
                                ),
                              );
                            } else
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                          },
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RoundedBottomNavBar(
        activeIndex: 1,
        isActive: true,
      ),
    );
  }
}
