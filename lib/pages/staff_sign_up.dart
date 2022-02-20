import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:padvisor/shared/constant_styles.dart';
import 'services/auth.dart';

class StaffSignUp extends StatefulWidget {
  const StaffSignUp({Key? key}) : super(key: key);

  @override
  _StaffSignUpState createState() => _StaffSignUpState();
}

class _StaffSignUpState extends State<StaffSignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final usertype = const [
    'advisor',
    'hod',
    'coordinator',
  ];

  String selectedType = '';

  @override
  void initState() {
    selectedType = usertype.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              width: 375,
              height: 660,
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
                    height: 50,
                  ),
                  const Text('SIGN UP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.tertiaryColor,
                          fontSize: 24.0,
                          fontFamily: "Reem Kufi")),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          SizedBox(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Name',
                                focusedBorder:
                                    WidgetStyleConstant.textFormField(),
                                enabledBorder:
                                    WidgetStyleConstant.textFormField(),
                                errorBorder: WidgetStyleConstant.textFormField(
                                    color: Colors.red),
                              ),
                              validator: (value) {
                                if (value!.length < 4) {
                                  return 'Please insert your name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Email',
                                focusedBorder:
                                    WidgetStyleConstant.textFormField(),
                                enabledBorder:
                                    WidgetStyleConstant.textFormField(),
                                errorBorder: WidgetStyleConstant.textFormField(
                                    color: Colors.red),
                              ),
                              validator: (value) {
                                const pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                final regExp = RegExp(pattern);

                                if (!regExp.hasMatch(value!)) {
                                  return 'Enter a valid email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                labelText: 'Password',
                                focusedBorder:
                                    WidgetStyleConstant.textFormField(),
                                enabledBorder:
                                    WidgetStyleConstant.textFormField(),
                                errorBorder: WidgetStyleConstant.textFormField(
                                    color: Colors.red),
                              ),
                              validator: (value) {
                                if (value!.length < 7) {
                                  return 'Password must be at least 7 characters long';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 22),
                          DropdownButtonFormField(
                            value: selectedType,
                            items: [
                              ...usertype.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(getType(e)),
                                );
                              }).toList()
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedType = value.toString();
                              });
                            },
                          ),
                          const SizedBox(height: 22),
                          InkWell(
                            onTap: () async {
                              final isValid = formKey.currentState!.validate();
                              if (isValid) {
                                formKey.currentState!.save();
                                AuthService authService = AuthService();
                                var res = await authService
                                    .registerWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text);

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(authService.userId)
                                    .set({
                                  'type': selectedType,
                                });

                                if (res != null && selectedType == 'advisor') {
                                  await FirebaseFirestore.instance
                                      .collection('advisors')
                                      .doc(authService.userId)
                                      .set({
                                    'cohorts': [],
                                    'name': _nameController.text,
                                  });
                                }

                                Navigator.pushNamed(context, 'signin');
                              }
                            },
                            child: Container(
                              width: 10,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 40),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                  const Text('Already have an account?'),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
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
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  getType(String e) {
    if (e == 'hod') {
      return 'Head of Department';
    } else if (e == 'advisor') {
      return 'Advisor';
    } else {
      return 'PA Coordinator';
    }
  }
}
