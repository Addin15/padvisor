import 'package:flutter/material.dart';
import 'package:padvisor/pages/services/auth.dart';
import 'package:padvisor/pages/sign_up.dart';
import 'package:padvisor/pages/staff_sign_up.dart';
import 'package:padvisor/pages/student/student_dashboard.dart';

import '../shared/color_constant.dart';
import '../shared/constant_styles.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 75),
                  width: 375,
                  height: 600,
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
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: WidgetStyleConstant.textFormField(),
                            enabledBorder: WidgetStyleConstant.textFormField(),
                            errorBorder: WidgetStyleConstant.textFormField(
                                color: Colors.red),
                          ),
                          validator: (value) {
                            const pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            final regExp = RegExp(pattern);

                            if (!regExp.hasMatch(value!)) {
                              return 'Incorrect email';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) => setState(() => email = value),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: 'Password',
                            focusedBorder: WidgetStyleConstant.textFormField(),
                            enabledBorder: WidgetStyleConstant.textFormField(),
                            errorBorder: WidgetStyleConstant.textFormField(
                                color: Colors.red),
                          ),
                          validator: (value) {
                            if (value!.length < 7) {
                              return 'incorrect password';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) =>
                              setState(() => password = value),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          final isValid = formKey.currentState!.validate();
                          if (isValid) {
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentDashboard()));
                            if (result == null) {
                              setState(() {
                                error =
                                    'could not sign in with those credentials';
                              });
                            }
                          }
                        },
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
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Container(
                  height: 100,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUp()));
                            },
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
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const StaffSignUp()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              decoration: BoxDecoration(
                                color: AppColor.tertiaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Staff Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
