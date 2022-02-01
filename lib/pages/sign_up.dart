import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:padvisor/shared/constant_styles.dart';

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
              height: 550,
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
            const SizedBox(height: 100),
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

class FirstForm extends StatelessWidget {
  const FirstForm(this._tabController, {Key? key}) : super(key: key);

  final TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(height: 22),
        InkWell(
          onTap: () {
            _tabController!.animateTo(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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

  Future pickImage() async {
    try {
      final XFile? pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      setState(() => image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10.0,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: InkWell(
                onTap: () => pickImage(),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                      image != null ? image!.path : 'assets/logo/unknown.png'),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
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
        const SizedBox(height: 22),
        InkWell(
          onTap: () {
            widget._tabController!.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
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
    );
  }
}
