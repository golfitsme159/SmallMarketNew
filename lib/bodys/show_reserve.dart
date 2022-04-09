import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/models/reserve_model.dart';
import 'package:smallmarket/states/details_reserve.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/widgets/show_progress.dart';
import 'package:smallmarket/widgets/show_title.dart';

class ShowReserve extends StatefulWidget {
  const ShowReserve({Key? key}) : super(key: key);

  @override
  _ShowReserveState createState() => _ShowReserveState();
}

class _ShowReserveState extends State<ShowReserve>
    with TickerProviderStateMixin {
  bool lond = true;
  bool? haveData;
  List<ReserveModel> reserveModels = [];
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
    tabController = TabController(length: 1, vsync: this);
  }

  Future<Null> loadValueFromAPI() async {
    if (reserveModels.length != 0) {
      reserveModels.clear();
    } else {}

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String M_ID = preferences.getString('M_ID')!;
    String apiGetReserve =
        '${MyConstant.domain}/smallmarket/getReserveWhereUser.php?isAdd=true&M_ID=$M_ID';
    await Dio().get(apiGetReserve).then((value) {
      // print('value ==> $value');

      if (value.toString() == 'null') {
        //No Data
        setState(() {
          lond = false;
          haveData = false;
        });
      } else {
        //Have Data
        for (var item in json.decode(value.data)) {
          ReserveModel model = ReserveModel.fromMap(item);
          print('Reserve ==> ${model.RES_Name}');

          setState(() {
            lond = false;
            haveData = true;
            reserveModels.add(model);
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
                                      'ตารางการจองของคุณ',
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
                                  title: 'ไม่มีการจอง',
                                  textStyle: MyTheme.heading2),
                              ShowTitle(
                                  title: 'กรุณาทำการจอง',
                                  textStyle: MyTheme.bodyText1),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyTheme.kPrimaryColor,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddReserve)
                .then((value) => loadValueFromAPI()),
        child: Icon(Icons.add),
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
              'หน้าจองล็อกจำหน่ายสินค้า',
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
        itemCount: reserveModels.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[400]!.withOpacity(0.5),
                  child: Icon(
                    FontAwesomeIcons.book,
                    color: MyConstant.w,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Container(
                  // padding: EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ShowTitle(
                            title: 'Lock : ${reserveModels[index].L_Name}',
                            textStyle: MyTheme.heading2,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print('## คุณต้องการยกเลิกการจอง $index');
                                    confirmDialogDelete(reserveModels[index]);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print('## You Cick Datails');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailReserve(
                                          detailModel: reserveModels[index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.more_horiz,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ShowTitle(
                        title:
                            'วันที่เช่า : ${reserveModels[index].RE_FirstDate} - ${reserveModels[index].RE_EndDate}',
                        textStyle: MyTheme.bodyTextMessage,
                      ),
                      ShowTitle(
                        title: 'สถานะ : ${reserveModels[index].RES_Name}',
                        textStyle: MyTheme.bodyTextMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<Null> confirmDialogDelete(ReserveModel reserveModels) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          title: ShowTitle(
            title: 'คุณต้องการยกเลิกใช่หรือไม่ ? ${reserveModels.L_Name}',
            textStyle: MyConstant().h2Stlye(),
          ),
          subtitle: ShowTitle(
            title: 'ทำการยกเลิกการจอง',
            textStyle: MyConstant().h3Stlye(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              print('## Confirm Delete at id ==> ${reserveModels.RE_ID}');
              String apiDeleteReserve =
                  '${MyConstant.domain}/smallmarket/deleteWhereId.php?isAdd=true&RE_ID=${reserveModels.RE_ID}';
              await Dio().get(apiDeleteReserve).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('ยืนยัน'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ย้อนกลับ'),
          ),
        ],
      ),
    );
  }
}
