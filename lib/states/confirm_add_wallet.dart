import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smallmarket/models/pay_model.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:smallmarket/widgets/show_image.dart';
import 'package:smallmarket/widgets/show_title.dart';

class ConfirmAddWallet extends StatefulWidget {
  const ConfirmAddWallet({Key? key}) : super(key: key);

  @override
  State<ConfirmAddWallet> createState() => _ConfirmAddWalletState();
}

class _ConfirmAddWalletState extends State<ConfirmAddWallet> {
  String? dateTimeStr;
  File? file;
  PayModel? AddPay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    findCurrentTime();
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();

    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    dateTimeStr = dateFormat.format(dateTime);
    print('dateTimeStr = $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ยืนยันการจ่ายเงิน'),
        leading: IconButton(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeHome, (route) => false),
          icon: Platform.isIOS
              ? Icon(Icons.arrow_back_ios)
              : Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newHeader(),
          newDateTimePay(),
          Spacer(),
          newImage(),
          Spacer(),
          newButton(),
        ],
      ),
    );
  }

  Container newButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (file == null) {
            MyDialog()
                .normalDialog(context, 'ยังไม่มีรูปภาพ', 'กรุณาอัพโหลดรูปภาพ');
          } else {
            processUploadAndUpdateData();
          }
        },
        child: Text('ยืนยัน'),
      ),
    );
  }

  Future<Null> processUploadAndUpdateData() async {
    String apiSaveSlip = '${MyConstant.domain}/smallmarket/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    MyDialog().showProgressDialog(context);

    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) {
        print('value = $value');
        Navigator.pop(context);
      });
    } catch (e) {}
  }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });

      final bytes = File(result!.path).readAsBytesSync();

      String img64 = base64Encode(bytes);
      print('b64 = $img64');
    } catch (e) {}
  }

  Row newImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.camera),
            icon: Icon(Icons.add_a_photo)),
        Container(
          width: 200,
          height: 200,
          child: file == null
              ? ShowImage(pathImage: 'images/bill.png')
              : Image.file(file!),
        ),
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.gallery),
            icon: Icon(Icons.add_photo_alternate)),
      ],
    );
  }

  ShowTitle newDateTimePay() {
    return ShowTitle(
      title: dateTimeStr == null ? 'dd/MM/yy HH:mm' : dateTimeStr!,
      textStyle: MyConstant().h2BlackStlye(),
    );
  }

  ShowTitle newHeader() {
    return ShowTitle(
      title: 'วันที่ชำระเงิน',
      textStyle: MyConstant().h1Stlye(),
    );
  }
}
