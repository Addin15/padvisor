import 'package:flutter/material.dart';

import 'color_constant.dart';

class WidgetStyleConstant {
  static textFormField({Color color = AppColor.primaryColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: color,
        width: 2,
        style: BorderStyle.solid,
      ),
    );
  }
}
