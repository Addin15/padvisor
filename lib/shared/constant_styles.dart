import 'package:flutter/material.dart';

import 'color_constant.dart';

class WidgetStyleConstant {
  static textFormField() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColor.primaryColor,
          width: 2,
          style: BorderStyle.solid,
        ),
      );
}
