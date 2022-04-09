import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:dio/dio.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formkey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size1.width * 0.1),
                    newAvatar(size1),
                    buildUser(size1),
                    buildPassword(size1),
                    buildName(size1),
                    buildPhoneNumber(size1),
                    buildCreate(size1),
                    // SizedBox(height: 25),
                    newBackLogin(context, size1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox newBackLogin(BuildContext context, Size size) {
    return SizedBox(
      height: size.height * 0.08,
      width: size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'มีบัญชีอยู่แล้ว?',
            style: MyConstant().h3WhiteStlye(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, MyConstant.routeLogin);
            },
            child: Text(
              'เข้าสู่ระบบ',
              style:
                  MyConstant().h3WhiteStlye().copyWith(color: MyConstant.kBlue),
            ),
          ),
        ],
      ),
    );
  }

  Center newAvatar(Size size1) {
    return Center(
      child: CircleAvatar(
        radius: size1.width * 0.14,
        backgroundColor: Colors.grey[400]!.withOpacity(0.5),
        child: Icon(
          FontAwesomeIcons.user,
          color: MyConstant.w,
          size: size1.width * 0.1,
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

  IconButton buildCreateAccount(String? typeUser) {
    return IconButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {}
      },
      icon: Icon(Icons.cloud_upload),
    );
  }

  Row buildCreate(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size.height * 0.08,
          width: size.width * 0.8,
          child: ElevatedButton(
            style: MyConstant().myButtonStyleNew(),
            onPressed: () {
              if (formkey.currentState!.validate()) {
                // MyDialog().normalDialog(context, title, message);
                print('กระบวนการแทรกลงในฐานข้อมูล');
                uplondDate();
              }
            },
            child: const Text('สมัคร'),
          ),
        ),
      ],
    );
  }

  Future<void> uplondDate() async {
    String M_Name = nameController.text;
    String M_User = userController.text;
    String M_Pass = passController.text;
    String M_Phonenumber = phoneController.text;
    print(
        '## M_User = $M_User,M_Pass = $M_Pass,M_Name = $M_Name,M_Phonenumber = $M_Phonenumber ##');

    String path =
        '${MyConstant.domain}/smallmarket/getUserWhereUser.php?isAdd=true&M_User=$M_User';
    await Dio().get(path).then((value) {
      print('## value ==>> $value');
      if (value.toString() == 'null') {
        print('## user OK');
        processInserMySQL(
            M_User: M_User,
            M_Pass: M_Pass,
            M_Name: M_Name,
            M_Phonenumber: M_Phonenumber);
      } else {
        MyDialog().normalDialog(context, 'Userซ้ำ', 'กรุณาเปลี่ยน User');
      }
    });
  }

  Future<void> processInserMySQL(
      {String? M_User,
      String? M_Pass,
      String? M_Name,
      String? M_Phonenumber}) async {
    String apiInserUser =
        '${MyConstant.domain}/smallmarket/insertUser.php?isAdd=true&M_User=$M_User&M_Pass=$M_Pass&M_Name=$M_Name&M_Phonenumber=$M_Phonenumber';
    await Dio().post(apiInserUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ทำการสมัครผิดพลาด!!!', 'กรุณากรอกข้อมูลใหม่');
      }
    });
  }

  Padding buildName(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.8,
        child: TextFormField(
          controller: nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกชื่อ - นามสกุล';
            } else {}
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: MyConstant().h3WhiteStlye(),
            labelText: 'name',
            prefixIcon: Icon(
              Icons.person,
              color: MyConstant.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          style: MyConstant().h2WhiteStlye(),
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }

  Padding buildPhoneNumber(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.8,
        child: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกเบอร์ติดต่อ';
            } else {}
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: MyConstant().h3WhiteStlye(),
            labelText: 'contact number',
            prefixIcon: Icon(
              Icons.phone,
              color: MyConstant.w,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          style: MyConstant().h2WhiteStlye(),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  Padding buildUser(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.8,
        child: TextFormField(
          controller: userController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก ID';
            } else {}
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: MyConstant().h3WhiteStlye(),
            labelText: 'username',
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.account_circle_outlined,
                color: MyConstant.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          style: MyConstant().h2WhiteStlye(),
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }

  Padding buildPassword(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: size.height * 0.08,
        width: size.width * 0.8,
        child: TextFormField(
          controller: passController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอกรหัสผ่าน';
            } else {}
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            labelStyle: MyConstant().h3WhiteStlye(),
            labelText: 'password',
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.password,
                color: MyConstant.w,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyConstant.w),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          style: MyConstant().h2WhiteStlye(),
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}
