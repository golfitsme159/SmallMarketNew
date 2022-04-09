import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smallmarket/models/user_model.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:smallmarket/widgets/show_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size1 = MediaQuery.of(context).size;
    return Stack(
      children: [
        newBG(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    newHeader(),
                    newUser(size1),
                    newPassword(size1),
                    const SizedBox(height: 25),
                    buildLogin(size1),
                    const SizedBox(height: 25),
                    buildCreateAccount(size1),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding newUser(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: userController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก User';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                FontAwesomeIcons.envelope,
                size: 30,
                color: MyConstant.w,
              ),
            ),
            hintText: 'username',
            hintStyle: MyConstant().kBodyText(),
          ),
          style: MyConstant().kBodyText(),
          // keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }

  Padding newPassword(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: passController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกรหัสผ่าน';
            } else {
              return null;
            }
          },
          obscureText: statusRedEye,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                FontAwesomeIcons.lock,
                size: 30,
                color: MyConstant.w,
              ),
            ),
            hintText: 'password',
            hintStyle: MyConstant().kBodyText(),
          ),
          style: MyConstant().kBodyText(),
          // keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  Flexible newHeader() {
    return Flexible(
      child: Center(
        child: Text(
          MyConstant.appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ShaderMask newBG() {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.center,
        colors: [Colors.black, Colors.transparent],
      ).createShader(rect),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyConstant.bg),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateAccount(Size size) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(
            title: 'ยังไม่มีบัญชี ?',
            textStyle: MyConstant().h3WhiteStlye(),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.routeCreateAccount),
            child: const Text('สมัครสมาชิก'),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: MyConstant.w))),
    );
  }

  Row buildLogin(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.08,
          width: size.width * 0.8,
          child: ElevatedButton(
            style: MyConstant().myButtonStyleNew(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                String M_User = userController.text;
                String M_Pass = passController.text;
                print('## usar = $M_User, password = $M_Pass ##');
                checkLogin(M_User, M_Pass);
              }
            },
            child: const Text('เข้าสู่ระบบ'),
          ),
        ),
      ],
    );
  }

  Future<void> checkLogin(String? M_User, String? M_Pass) async {
    String apiCheckLogin =
        '${MyConstant.domain}/smallmarket/getUserWhereUser.php?isAdd=true&M_User=$M_User';
    await Dio().get(apiCheckLogin).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog()
            .normalDialog(context, 'User ผิด!!!', 'ไม่มี User นี้อยู่ในระบบ');
      } else {
        for (var itme in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(itme);
          if (M_Pass == model.M_Pass) {
            // Success Login
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('M_ID', model.M_ID!);
            preferences.setString('M_User', model.M_User!);
            preferences.setString('M_Name', model.M_Name!);
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeHome, (route) => false);
          } else {
            // Login False
            MyDialog().normalDialog(
                context, 'รหัสผ่านผิด!!', 'กรุณากรอกรหัสผ่านใหม่');
          }
        }
      }
    });
  }
}
