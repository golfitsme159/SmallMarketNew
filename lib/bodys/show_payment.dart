import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/bodys/bank.dart';
import 'package:smallmarket/models/pay_model.dart';
import 'package:smallmarket/models/reserve_model.dart';
import 'package:smallmarket/states/add_payment.dart';
import 'package:smallmarket/states/details_reserve.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/widgets/show_progress.dart';
import 'package:smallmarket/widgets/show_title.dart';

class ShowPayment extends StatefulWidget {
  const ShowPayment({Key? key}) : super(key: key);

  @override
  _ShowPaymentState createState() => _ShowPaymentState();
}

class _ShowPaymentState extends State<ShowPayment>
    with TickerProviderStateMixin {
  bool lond = true;
  bool? haveData;
  List<PayModel> payModels = [];
  TabController? tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    londValueFromAPI();
    tabController = TabController(length: 1, vsync: this);
  }

  Future<Null> londValueFromAPI() async {
    if (payModels.length != 0) {
      payModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String M_ID = preferences.getString('M_ID')!;
    String apiGetPay =
        '${MyConstant.domain}/smallmarket/getPayWhereUser.php?isAdd=true&M_ID=$M_ID';
    await Dio().get(apiGetPay).then((value) {
      print('value ==> $value');

      if (value.toString() == 'null') {
        //No Data
        setState(() {
          lond = false;
          haveData = false;
        });
      } else {
        //Have Data
        for (var item in json.decode(value.data)) {
          PayModel model = PayModel.fromMap(item);
          print('PayID ==> ${model.Pay_ID}');

          setState(() {
            lond = false;
            haveData = true;
            payModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.kPrimaryColor,
      body: Column(
        children: [
          TabBer(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: lond
                  ? const ShowProgress()
                  : haveData!
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      'ตารางการชำระเงินของคุณ',
                                      style: MyTheme.heading2,
                                    ),
                                  ],
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    buildListView(constraints),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShowTitle(
                                  title: 'NO DATE',
                                  textStyle: MyTheme.heading2),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Container TabBer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 80,
      color: MyTheme.kPrimaryColor,
      child: TabBar(
        controller: tabController,
        indicator: ShapeDecoration(
          // color: MyTheme.kAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        tabs: [
          Tab(
            icon: Text(
              'หน้าชำระเงิน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: payModels.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[400]!.withOpacity(0.5),
                child: Icon(
                  FontAwesomeIcons.circleDollarToSlot,
                  color: MyConstant.w,
                  size: 30,
                ),
              ),
              SizedBox(width: 15),
              Container(
                // padding: EdgeInsets.all(4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShowTitle(
                          title: 'Lock : ${payModels[index].L_Name}',
                          textStyle: MyTheme.heading2,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  print('## You Cick Payment');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Bank(
                                        AddPay: payModels[index],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  FontAwesomeIcons.moneyBill,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ShowTitle(
                      title: 'ราคา : ${payModels[index].Price}',
                      textStyle: MyTheme.bodyTextMessage,
                    ),
                    ShowTitle(
                      title: 'สถานะ : ${payModels[index].PS_Name}',
                      textStyle: MyTheme.bodyTextMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
