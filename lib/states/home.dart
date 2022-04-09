import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/bodys/show_payment.dart';
import 'package:smallmarket/bodys/show_rent.dart';
import 'package:smallmarket/bodys/show_reserve.dart';
import 'package:smallmarket/models/rent_model.dart';
import 'package:smallmarket/models/reserve_model.dart';
import 'package:smallmarket/models/user_model.dart';
import 'package:smallmarket/states/details_reserve.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/widgets/show_signout.dart';
import 'package:smallmarket/widgets/show_title.dart';

import '../widgets/my_tab_ber.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? tabController;
  List<ReserveModel> reserveModels = [];
  List<RentModel> rentModels = [];
  bool lond = true;
  bool? haveData;
  List<Widget> widgets = [
    ShowReserve(),
    ShowRent(),
    ShowPayment(),
  ];
  int indexWidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    findUserModel();
    tabController = TabController(length: 3, vsync: this);
  }

  Future<Null> findUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('M_User')!;
    print('## ID Logined == $id');
    String apiGetUserWhereUser =
        '${MyConstant.domain}/smallmarket/getUserWhereUser.php?isAdd=true&M_User=$id';
    await Dio().get(apiGetUserWhereUser).then((value) {
      print('## value == >$value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('### name logined = ${userModel!.M_Name}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.kPrimaryColor,
        // leading: IconButton(
        //   // ปุ่มเมนู
        //   onPressed: () {},
        //   icon: Icon(Icons.menu),
        // ),
        title: Center(
          child: Text(
            MyConstant.appName,
            style: MyTheme.kAppTitle,
          ),
        ),
        actions: [
          // ปุ่มออก
          IconButton(
              onPressed: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.clear().then(
                      (value) => Navigator.pushNamedAndRemoveUntil(
                          context, MyConstant.routeLogin, (route) => false),
                    );
              },
              icon: Icon(Icons.exit_to_app_outlined))
        ],
      ),
      backgroundColor: MyTheme.kPrimaryColor,
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHead(size1),
                menuShowReserve(),
                menuShowRent(),
                menuShowPayment(),
              ],
            )
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  UserAccountsDrawerHeader buildHead(Size size1) {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        CircleAvatar(
          radius: size1.width * 0.14,
          backgroundColor: Colors.grey[400]!.withOpacity(0.5),
          child: IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeEditProfile),
            icon: Icon(FontAwesomeIcons.user),
            iconSize: size1.width * 0.05,
            color: MyConstant.w,
            tooltip: 'แก้ไขข้อมูลส่วนตัว',
          ),
        ),
      ],
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [MyTheme.kPrimaryColor, MyTheme.kPrimaryColorVariant],
          center: Alignment(-0.8, -0.2),
          radius: 1,
        ),
      ),
      accountName: Text(
        userModel == null ? 'Name ?' : userModel!.M_Name!,
        style: MyTheme.chatSenderName,
      ),
      accountEmail: null,
    );
  }

  ListTile menuShowReserve() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_1),
      title: ShowTitle(
        title: 'แสดงการจองแผง',
        textStyle: MyTheme.heading2,
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดการจองแผง',
        textStyle: MyTheme.bodyText1,
      ),
    );
  }

  ListTile menuShowRent() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_2),
      title: ShowTitle(
        title: 'แสดงการเช่าแผง',
        textStyle: MyTheme.heading2,
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดการเช่าแผง',
        textStyle: MyTheme.bodyText1,
      ),
    );
  }

  ListTile menuShowPayment() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
          Navigator.pop(context);
        });
      },
      leading: Icon(Icons.filter_3),
      title: ShowTitle(
        title: 'แสดงการชำระเงิน',
        textStyle: MyTheme.heading2,
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียดการชำระเงิน',
        textStyle: MyTheme.bodyText1,
      ),
    );
  }
}
