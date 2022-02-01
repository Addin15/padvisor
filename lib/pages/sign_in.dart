import 'package:flutter/material.dart';

import '../shared/color_constant.dart';
import '../shared/constant_styles.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 75),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50.0,
                    ),
                    Image.asset(
                      'assets/logo/logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    const Text('SIGN IN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColor.tertiaryColor,
                            fontSize: 24.0,
                            fontFamily: "Reem Kufi")),
                    const SizedBox(
                      height: 5.0,
                    ),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: WidgetStyleConstant.textFormField(),
                          enabledBorder: WidgetStyleConstant.textFormField(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: WidgetStyleConstant.textFormField(),
                          enabledBorder: WidgetStyleConstant.textFormField(),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                          color: AppColor.tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(
                      color: AppColor.primaryColor,
                      width: 3,
                    ),
                  ),
                  color: AppColor.primaryColor.withAlpha(37),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Didn\'t have an account'),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                          color: AppColor.tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
