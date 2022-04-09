import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/states/add_payment.dart';
import 'package:smallmarket/states/add_reserve.dart';
import 'package:smallmarket/states/confirm_add_wallet.dart';
import 'package:smallmarket/states/create_account.dart';
import 'package:smallmarket/states/edit_profile.dart';
import 'package:smallmarket/states/home.dart';
import 'package:smallmarket/states/login.dart';
import 'package:smallmarket/states/rent.dart';
import 'package:smallmarket/states/reserve.dart';
import 'package:smallmarket/utillity/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => Login(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/home': (BuildContext context) => Home(),
  '/reserve': (BuildContext context) => Reserve(),
  '/rent': (BuildContext context) => Rent(),
  '/add_reserve': (BuildContext context) => AddReserve(),
  '/edit_profile': (BuildContext context) => EditProfile(),
  // MyConstant.routeAddPayment: (BuildContext context) => AddPayment(),
  MyConstant.routeConfirmAddWallet: (BuildContext context) =>
      ConfirmAddWallet(),
};

String? initialRoute;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  // print('## TYPE ====> $type');
  if (type?.isEmpty ?? true) {
    initialRoute = MyConstant.routeLogin;
    runApp(MyApp());
  } else {
    initialRoute = MyConstant.routeHome;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(
        primaryColor: MyTheme.kPrimaryColor,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: MyTheme.kAccentColor),
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
