// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/models/lock_model.dart';
import 'package:smallmarket/states/datePicker.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:http/http.dart' as http;
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:smallmarket/widgets/show_title.dart';

class AddReserve extends StatefulWidget {
  const AddReserve({Key? key}) : super(key: key);

  @override
  _AddReserveState createState() => _AddReserveState();
}

class _AddReserveState extends State<AddReserve> {
  final formkey = GlobalKey<FormState>();
  DateTime? dateTime;
  String? dropdownMonth;
  String? dropdownYear;
  int? row;

  String? pilihTanggal;
  String labelText = '';
  DateTime tgl = new DateTime.now();
  DateTime? end;

  String? selectedName;
  List data = [];

  Future getAllName() async {
    var url = Uri.parse('http://192.168.1.44/smallmarket/lock.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody);

    setState(() {
      data = jsonData;
    });
    print(jsonData);
    return "success";
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != tgl) {
      setState(() {
        if (row == 1) {
          tgl = picked;
          pilihTanggal = new DateFormat.yMd().format(tgl);
          end = DateTime(tgl.year, tgl.month, tgl.day + 1);
        } else {
          tgl = picked;
          pilihTanggal = new DateFormat.yMd().format(tgl);
          end = DateTime(tgl.year, tgl.month + 1, tgl.day);
        }
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.kPrimaryColor,
        title: Text(
          'ทำการจองแผง',
          style: MyTheme.chatSenderName,
        ),
      ),
      backgroundColor: MyTheme.kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 150),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: buildListForm(size),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildListForm(double size) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          ShowTitle(
            title: 'รายการจอง',
            textStyle: MyTheme.heading2,
          ),
          newRadio(),
          ShowTitle(
            title: 'เลือกเดือนที่เช่า',
            textStyle: MyTheme.bodyTextMessage,
          ),
          DateDropDown(
            labelText: labelText,
            valueText: new DateFormat.yMd().format(tgl),
            onPressed: () {
              _selectedDate(context);
            },
          ),
          SizedBox(
            height: 25,
          ),
          ShowTitle(
            title: 'เลือกล็อกที่ต้องการจอง',
            textStyle: MyTheme.bodyTextMessage,
          ),
          buildDropLock(),
          SizedBox(
            height: 25,
          ),
          buildConfirm(size),
        ],
      ),
    );
  }

  Column newRadio() {
    return Column(
      children: [
        ListTile(
          title: Text(
            'รายวัน',
            style: MyTheme.bodyTextMessage,
          ),
          leading: Radio(
            value: 1,
            groupValue: row,
            onChanged: (int? value) {
              setState(
                () {
                  row = value;
                },
              );
            },
          ),
        ),
        ListTile(
          title: Text(
            'รายเดือน',
            style: MyTheme.bodyTextMessage,
          ),
          leading: Radio(
            value: 2,
            groupValue: row,
            onChanged: (int? value) {
              setState(
                () {
                  row = value;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Center buildDropLock() {
    return Center(
      child: DropdownButton(
        value: selectedName,
        hint: const Text(
          'กรุณาเลือก',
          style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
        items: data.map(
          (list) {
            return DropdownMenuItem(
              child: Text(list['L_Name']!),
              value: list['L_ID']!.toString(),
            );
          },
        ).toList(),
        onChanged: (String? lock) {
          setState(() {
            selectedName = lock;
          });
        },
      ),
    );
  }

  Row buildConfirm(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
          ),
          width: size * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyleNew(),
            onPressed: () {
              if (formkey.currentState!.validate()) {
                // MyDialog().normalDialog(context, title, message);
                print('กระบวนการแทรกลงในฐานข้อมูล');
                uplondReserve();
              }
            },
            child: Text('ตกลง'),
          ),
        ),
      ],
    );
  }

  Future<void> uplondReserve() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String M_ID = preferences.getString('M_ID')!;
    String? RE_FirstDate = '$tgl';
    String? RE_EndDate = '$end';
    String? L_ID = selectedName;
    String? RES_ID = '5';
    print(
        '## วันที่ต้องการเช่า = $RE_FirstDate, วันที่สิ้นสุดการเช่า = $RE_EndDate, ล็อก = $L_ID , สถานะ = $RES_ID , เลขสมาชิก = $M_ID');
    String path =
        '${MyConstant.domain}/smallmarket/getReserveWhereDateLock.php?isAdd=true&RE_FirstDate	=$RE_FirstDate&L_ID=$L_ID';
    await Dio().get(path).then((value) {
      print('## value => $value');
      if (value.toString() == 'null') {
        print('## Reserve OK');
        processInserReseve(
            RE_FirstDate: RE_FirstDate,
            RE_EndDate: RE_EndDate,
            L_ID: L_ID,
            RES_ID: RES_ID,
            M_ID: M_ID);
      } else {
        MyDialog().normalDialog(context, 'มีการจองวันที่ $RE_FirstDate ไปแล้ว',
            'กรุณาเปลี่ยนวันที่จอง หรือล็อคที่จอง');
      }
    });
  }

  Future<void> processInserReseve(
      {String? RE_FirstDate,
      String? RE_EndDate,
      String? L_ID,
      String? RES_ID,
      String? M_ID}) async {
    String apiInserReseve =
        '${MyConstant.domain}/smallmarket/insertReserve.php?isAdd=true&RE_FirstDate=$RE_FirstDate&RE_EndDate=$RE_EndDate&L_ID=$L_ID&RES_ID=$RES_ID&M_ID=$M_ID';
    await Dio().post(apiInserReseve).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(context, 'ทำการจองผิดพลาด!!!', 'กรุณาจองใหม่');
      }
    });
  }
}
