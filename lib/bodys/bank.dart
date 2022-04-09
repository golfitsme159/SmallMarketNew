import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:smallmarket/models/pay_model.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:smallmarket/widgets/show_image.dart';
import 'package:smallmarket/widgets/show_progress.dart';
import 'package:smallmarket/widgets/show_title.dart';

class Bank extends StatefulWidget {
  final PayModel? AddPay;
  const Bank({Key? key, required this.AddPay}) : super(key: key);

  @override
  State<Bank> createState() => _BankState();
}

class _BankState extends State<Bank> {
  PayModel? AddPay;
  String? ID;
  String? dateTimeStr;
  File? file;
  String? img64;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrentTime();
    AddPay = widget.AddPay;
    ID = AddPay!.Pay_ID;
    print('## ID Payment ==> ${AddPay!.Pay_ID}');
  }

  void findCurrentTime() {
    DateTime dateTime = DateTime.now();

    DateFormat dateFormat = DateFormat('yyyy/MM/dd');

    dateTimeStr = dateFormat.format(dateTime);
    print('dateTimeStr = $dateTimeStr');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ชำระเงิน'),
      ),
      body: Column(
        children: [
          buildTitle(),
          buildKTB(),
          buildCopyPrompay(),
          buildQRcode(),
          const Spacer(),
          newHeader(),
          // newDateTimePay(),
          const Spacer(),
          newImage(),
          const Spacer(),
          newButton(),
        ],
      ),
      // floatingActionButton: NavConfirmAddWallet(),
    );
  }

  Widget buildKTB() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      height: 150,
      child: Center(
        child: Card(
          color: Colors.blueAccent,
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/ktb.svg'),
              ),
            ),
            title: ShowTitle(
              title: 'ธนาคารกรุงไทย',
              textStyle: MyConstant().h2WhiteStlye(),
            ),
            subtitle: ShowTitle(
              title: 'ชื่อบัญชี นาย----- ------ เลขบัญชี 913-0-04149-5 ',
              textStyle: MyConstant().h3WhiteStlye(),
            ),
          ),
        ),
      ),
    );
  }

  Container buildQRcode() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: CachedNetworkImage(
        width: 150,
        imageUrl: MyConstant.urlPromptpay,
        placeholder: (context, url) => const ShowProgress(),
      ),
    );
  }

  Widget buildCopyPrompay() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Card(
        color: Colors.lime,
        child: ListTile(
          title: ShowTitle(
            title: '0910488104',
            textStyle: MyConstant().h1BlackStlye(),
          ),
          subtitle: ShowTitle(
            title: 'บัญชีพร้อมเพย์',
            textStyle: MyConstant().h3BlackStlye(),
          ),
          trailing: IconButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: '0910488104'));
              MyDialog().normalDialog(context, 'คัดลอกพร้อมเพย์',
                  'กรุณาไปที่แอพธนาคารของท่านเพื่อโอนเงินผ่าน พร้อมเพย์');
            },
            icon: Icon(
              Icons.copy,
              color: MyConstant.dart,
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: 'การโอนเงินเข้าบัญชีธนาคาร & พร้อมเพย์',
        textStyle: MyConstant().h2Stlye(),
      ),
    );
  }

  SizedBox newButton() {
    return SizedBox(
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
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Future<void> processUploadAndUpdateData() async {
    // อัพโหลดรูปไปยังเซิฟเวอร์
    String apiSaveSlip = '${MyConstant.domain}/smallmarket/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';
    MyDialog().showProgressDialog(context);

    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) async {
        print('value = $value');
        Navigator.pop(context);

        // MySql Update Payment
        var pathSlip = nameSlip;
        print(
            'Pay_ID=${AddPay!.Pay_ID},Pay_Date=$dateTimeStr,Silp = $pathSlip');
        var urlAPIupdate =
            '${MyConstant.domain}/smallmarket/UpdatePayment.php?isAdd=true&Pay_ID=${AddPay!.Pay_ID}&Pay_Date=$dateTimeStr&Slip_Filename=$pathSlip';
        await Dio().get(urlAPIupdate).then(
              (value) => MyDialog(funcAction: success).actionDialog(
                context,
                'ยืนยันสำเร็จ',
                'ทำการส่งสลิปสำเร็จ รอทางเจ้าของตลาดตรวจสอบ',
              ),
            );
      });
    } catch (e) {}
  }

  void success() {
    Navigator.pushNamedAndRemoveUntil(
        context, MyConstant.routeHome, (route) => false);
    print('Success Work');
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
    } catch (e) {}
  }

  Row newImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.camera),
            icon: const Icon(Icons.add_a_photo)),
        SizedBox(
          width: 80,
          height: 80,
          child: file == null
              ? const ShowImage(pathImage: 'images/bill.png')
              : Image.file(file!),
        ),
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.gallery),
            icon: const Icon(Icons.add_photo_alternate)),
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
      title: 'อัพโหลดรูปสลิป',
      textStyle: MyConstant().h3Stlye(),
    );
  }
}
