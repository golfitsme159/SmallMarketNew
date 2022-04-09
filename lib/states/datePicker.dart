// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smallmarket/utillity/my_constant.dart';

class DateDropDown extends StatelessWidget {
  final String labelText;
  final String valueText;
  final VoidCallback onPressed;

  const DateDropDown({
    Key? key,
    required this.labelText,
    required this.valueText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText),
        baseStyle: MyConstant().h2Stlye(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              valueText,
              style: MyConstant().h2Stlye(),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            )
          ],
        ),
      ),
    );
  }
}
