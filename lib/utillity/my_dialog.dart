import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smallmarket/widgets/show_image.dart';
import 'package:smallmarket/widgets/show_title.dart';
import 'package:smallmarket/utillity/my_constant.dart';

class MyDialog {
  final Function()? funcAction;

  MyDialog({this.funcAction});
  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )),
        onWillPop: () async {
          return false;
        },
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image1),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2Stlye(),
          ),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Stlye()),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  Future<Null> actionDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(pathImage: MyConstant.image1),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Stlye()),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3Stlye()),
        ),
        actions: [
          TextButton(
            onPressed: funcAction,
            child: Text('OK'),
          ),
          // TextButton(
          //   onPressed: () => Navigator.pop(context),
          //   child: Text('Cancel'),
          // ),
        ],
      ),
    );
  }
}
