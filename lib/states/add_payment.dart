import 'package:flutter/material.dart';
import 'package:smallmarket/bodys/bank.dart';
import 'package:smallmarket/bodys/prompay.dart';
import 'package:smallmarket/models/pay_model.dart';
import 'package:smallmarket/utillity/my_constant.dart';

class AddPayment extends StatefulWidget {
  final PayModel? AddPay;
  const AddPayment({Key? key, required this.AddPay}) : super(key: key);

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  PayModel? AddPay;
  String? ID;
  List<Widget> widgets = [
    // Bank(),
    Prompay(),
  ];

  List<IconData> icons = [
    Icons.account_balance,
    Icons.qr_code,
  ];

  List<String> titles = [
    'ธนาคาร',
    'พร้อมเพย์',
  ];

  int indexPosition = 0;

  List<BottomNavigationBarItem> bottomNavigationBerItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AddPay = widget.AddPay;
    print('## ID Payment ==> ${AddPay!.Pay_ID}');

    int i = 0;
    for (var item in titles) {
      bottomNavigationBerItems
          .add(createBottomNavigationBerItme(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBerItme(
          IconData iconData, String string) =>
      BottomNavigationBarItem(
        icon: Icon(iconData),
        label: string,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชำระเงิน'),
      ),
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: MyConstant.dart),
        unselectedIconTheme: IconThemeData(color: MyConstant.primary),
        selectedItemColor: MyConstant.dart,
        unselectedItemColor: MyConstant.primary,
        items: bottomNavigationBerItems,
        currentIndex: indexPosition,
        onTap: (value) {
          setState(() {
            indexPosition = value;
            ID = AddPay!.Pay_ID;
          });
        },
      ),
    );
  }
}
