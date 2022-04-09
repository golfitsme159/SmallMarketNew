import 'package:flutter/material.dart';
import 'package:smallmarket/utillity/my_constant.dart';

class MyTabBer extends StatelessWidget {
  const MyTabBer({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  final TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      height: 80,
      color: MyTheme.kPrimaryColor,
      child: TabBar(
        controller: tabController,
        indicator: ShapeDecoration(
          color: MyTheme.kAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        tabs: [
          Tab(
            icon: Text(
              'จอง',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Tab(
            icon: Text(
              'เช่า',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Tab(
            icon: Text(
              'ชำระเงิน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
