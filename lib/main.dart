import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/models/user.dart';
import 'data/providers/UserProvider.dart';
import 'services/api/api.dart';
import 'services/navigation/router.dart' as router;
import 'services/navigation/routing_constants.dart';
import 'services/navigation/routing_constants.dart';
import 'utils/constants.dart';
import 'views/pages/pages.dart';

void main() async {
  // Ensure App Initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // If you have to initialize someting or run
  // some async tasks you can make the main()
  // function async and perform those tasks
  // in here before launching the app. While
  // performing these tasks the app will show
  // the static splash screen.

  final _prefs = await SharedPreferences.getInstance();
  final userJsonString = _prefs.getString(SHARED_PREF_RECOM_USER_KEY);
  //print('Print from main.dart');
  User user;
  if (userJsonString != null) {
    //print('Print from main.dart=>' + json.decode(userJsonString).toString());
    var loggedInUser = User.fromJson(json.decode(userJsonString));

    var now = DateTime.now();
    var expireTime = now;
    try{
      expireTime = DateTime.parse(json.decode(userJsonString)['expireTime']) ;  //;
     }
    catch(e){
      expireTime= now;
    }
    // print('nowTime ================');
    // print(now.toString());
    // print('expireTime ================');
    // print(expireTime.toString());

    // user= loggedInUser;
    // user.accessToken = 'Bearer '+ user.accessToken;

    if(!expireTime.isBefore(now)){
      user= loggedInUser;
      user.accessToken = 'Bearer '+ user.accessToken;
    }
  }

  // Locking App Orientation in Portrait Mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(App(loggedInUser: user));
}

class App extends StatelessWidget {
  final User loggedInUser;

  const App({Key key, this.loggedInUser}) : super(key: key);
  // This widget is the root of your application.

  // Initialize the app with provides. If you have
  // multiple providers use MultiProvider().

  // If you want to have a dynamic home then don't
  // use route name to specify it. Create the Page
  // and directly pass it.x
  // e.g: home: <conditional> ? A() : B()

  // TODO: Setup Splash Screen

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService(token: loggedInUser?.accessToken)),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(user: loggedInUser)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner:false,
        title: 'Telant X',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          buttonColor: kPrimaryColor,
        ),
        home: loggedInUser != null ? HomePage() : SignInPage(),
        onGenerateRoute: router.generateRoute,
        //initialRoute: SIGN_IN_PAGE,
      ),
    );
  }
}
