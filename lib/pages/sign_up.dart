import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padvisor/pages/model/user.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:padvisor/shared/constant_styles.dart';
import 'services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          FirstForm(_tabController),
                          SecondForm(_tabController),
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
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _matricNoController = TextEditingController();

class FirstForm extends StatefulWidget {
  const FirstForm(this._tabController, {Key? key}) : super(key: key);

  final TabController? _tabController;

  @override
  State<FirstForm> createState() => _FirstFormState();
}

class _FirstFormState extends State<FirstForm> {
  final formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
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
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
                errorBorder:
                    WidgetStyleConstant.textFormField(color: Colors.red),
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
              controller: _matricNoController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                labelText: 'Matric Number',
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
                errorBorder:
                    WidgetStyleConstant.textFormField(color: Colors.red),
              ),
              validator: (value) {
                if (value!.length != 6) {
                  return 'Matric number is incorrect';
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
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
                errorBorder:
                    WidgetStyleConstant.textFormField(color: Colors.red),
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
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
                errorBorder:
                    WidgetStyleConstant.textFormField(color: Colors.red),
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
          InkWell(
            onTap: () async {
              final isValid = formKey.currentState!.validate();
              if (isValid) {
                formKey.currentState!.save();
                widget._tabController!.animateTo(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }
            },
            child: Container(
              width: 10,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              margin: const EdgeInsets.symmetric(horizontal: 45),
              decoration: BoxDecoration(
                color: AppColor.tertiaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondForm extends StatefulWidget {
  const SecondForm(this._tabController, {Key? key}) : super(key: key);

  final TabController? _tabController;

  @override
  State<SecondForm> createState() => _SecondFormState();
}

class _SecondFormState extends State<SecondForm> {
  File? image;
  final AuthService _auth = AuthService();

  Future pickImageCamera() async {
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageGallery() async {
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      setState(() {
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _getImage() {
    if (image != null) return FileImage(File(image!.path));
    return const AssetImage('assets/logo/unknown.png');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ListView(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 60),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Material(
                type: MaterialType.transparency,
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await openDialog();
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _getImage(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                focusedBorder: WidgetStyleConstant.textFormField(),
                enabledBorder: WidgetStyleConstant.textFormField(),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: () {
                      widget._tabController!.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withAlpha(128),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          _emailController.text, _passwordController.text);

                      if (result != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc((result as Users).uid)
                            .set({
                          'name': _nameController.text,
                          'matricNo': _matricNoController.text,
                        });
                      }
                      print(_emailController.text);
                      print(_passwordController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future openDialog() async {
    dynamic val = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Photo From'),
        content: SizedBox(
          width: 100,
          height: 100,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: AppColor.tertiaryColor),
                  onPressed: () {
                    Navigator.pop(context, {'type': 0});
                  },
                  child: const Text('Camera'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: AppColor.tertiaryColor),
                  onPressed: () {
                    Navigator.pop(context, {'type': 1});
                  },
                  child: const Text('Gallery'),
                ),
              ]),
        ),
      ),
    );

    if (val != null) {
      if (val['type'] == 0) {
        await pickImageCamera();
      } else if (val['type'] == 1) {
        await pickImageGallery();
      }
    }
  }
}
