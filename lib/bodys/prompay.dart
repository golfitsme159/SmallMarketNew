import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smallmarket/utillity/my_constant.dart';
import 'package:smallmarket/utillity/my_dialog.dart';
import 'package:smallmarket/widgets/nav_confirm_add_wallet.dart';
import 'package:smallmarket/widgets/show_progress.dart';
import 'package:smallmarket/widgets/show_title.dart';

class Prompay extends StatefulWidget {
  const Prompay({Key? key}) : super(key: key);

  @override
  State<Prompay> createState() => _PrompayState();
}

class _PrompayState extends State<Prompay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            buildCopyPrompay(),
            buildQRcode(),
          ],
        ),
      ),
      floatingActionButton: NavConfirmAddWallet(),
    );
  }

  Container buildQRcode() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: CachedNetworkImage(
        imageUrl: MyConstant.urlPromptpay,
        placeholder: (context, url) => ShowProgress(),
      ),
    );
  }

  Widget buildCopyPrompay() {
    return Container(
      margin: EdgeInsets.symmetric(
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
              Clipboard.setData(ClipboardData(text: '0910488104'));
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

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'การโอนเงินโดยใช้ พร้อมเพย์',
      textStyle: MyConstant().h2Stlye(),
    );
  }
}
