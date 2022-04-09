import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/models/user_model.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/widgets/show_title.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // LatLng? latLng;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user = preferences.getString('M_User')!;

    String apiGetUser =
        '${MyConstant.domain}/smallmarket/getUserWhereUser.php?isAdd=true&M_User=$user';
    await Dio().get(apiGetUser).then((value) {
      print('value from API ==> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.M_Name!;
          phoneController.text = userModel!.M_Phonenumber!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('แก้ไขข้อมูลส่วนตัว'),
          backgroundColor: MyTheme.kPrimaryColor,
          actions: [
            IconButton(
              onPressed: () => processEditProfile(),
              icon: Icon(Icons.edit),
              tooltip: 'ยืนยันการแก้ไข',
            )
          ],
        ),
        backgroundColor: MyTheme.kPrimaryColor,
        body: LayoutBuilder(
          builder: (context, constraints) => GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: 180),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    buildTitle('ข้อมูลทั่วไป'),
                    buildName(constraints),
                    buildPhone(constraints),
                    buildEditProfile(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<Null> processEditProfile() async {
    print('processEditProfile');
    if (formKey.currentState!.validate()) {
      editValueToMySQL();
    }
  }

  Future<Null> editValueToMySQL() async {
    print('แก้ไข');
    String apiEditProfile =
        '${MyConstant.domain}/smallmarket/editUserWhereUser.php?isAdd=true&M_ID=${userModel!.M_ID}&M_Name=${nameController.text}&M_Phonenumber=${phoneController.text}';
    await Dio().get(apiEditProfile).then((value) => Navigator.pop(context));
  }

  ElevatedButton buildEditProfile() {
    return ElevatedButton.icon(
      style: MyConstant().myButtonStyleNew(),
      onPressed: () => processEditProfile(),
      icon: Icon(Icons.edit),
      label: Text('ยืนยันการแก้ไข'),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อ';
              } else {
                return null;
              }
            },
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'ชื่อ :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
          ),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทร';
              } else {
                return null;
              }
            },
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'เบอร์โทร :',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyTheme.heading2,
    );
  }
}
