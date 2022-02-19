import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:padvisor/pages/model/student.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:image_picker/image_picker.dart';

import '../services/database.dart';
import '../services/auth.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool showPassword = false;
  DatabaseService db = DatabaseService();
  AuthService auth = AuthService();
  File? image;
  String? downloadURL = '';

  bool notChanged = true;

  Future pickImageCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) return;

      setState(() {
        image = File(pickedImage.path);
        notChanged = false;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      setState(() {
        image = File(pickedImage.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("image/${DateTime.now().millisecondsSinceEpoch.toString()}");
    TaskSnapshot taskSnapshot = await ref.putFile(image!);
    downloadURL = await taskSnapshot.ref.getDownloadURL();
    print(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.getUser(auth.userId),
      builder: (context, AsyncSnapshot<Students> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: SpinKitThreeInOut(
              color: AppColor.tertiaryColor,
            ),
          );
        } else {
          Students? user = snapshot.data;
          TextEditingController nameController =
              TextEditingController(text: user!.name);
          TextEditingController noMatricController =
              TextEditingController(text: user.matricNo);
          TextEditingController whatsAppController =
              TextEditingController(text: user.whatsApp);
          TextEditingController weChatController =
              TextEditingController(text: user.weChat);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/logo/logo_white.png',
                  width: 30,
                  height: 30,
                ),
              ),
              elevation: 0.0,
              backgroundColor: AppColor.primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()));
                    },
                    icon: const Icon(Icons.logout_outlined)),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: 375,
              height: 660,
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    ProfileWidget(
                      imagePath: user.url!,
                      onClicked: () async {
                        await openDialog();
                      },
                      notChanged: notChanged,
                      image: image,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    buildTextField("Full Name", nameController, false),
                    const SizedBox(height: 10),
                    buildTextField("Matric Number", noMatricController, false),
                    const SizedBox(height: 10),
                    buildTextField("WhatsApp", whatsAppController, false),
                    const SizedBox(height: 10),
                    buildTextField("WeChat", weChatController, false),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColor.tertiaryColor,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () async {
                            if (image != null) {
                              await uploadImage();
                            }
                            await db.saveStudent(auth.userId, {
                              'url': downloadURL,
                              'name': nameController.text,
                              'matricNo': noMatricController.text,
                              'weChat': weChatController.text,
                              'whatsApp': whatsAppController.text,
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  TextField buildTextField(String labelText, TextEditingController controller,
      bool isPasswordTextField) {
    return TextField(
      obscureText: isPasswordTextField ? showPassword : false,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPasswordTextField
            ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.grey,
                ),
              )
            : null,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(
            color: AppColor.tertiaryColor,
            fontSize: 18.0,
            fontFamily: "Reem Kufi"),
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

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool notChanged;
  final File? image;

  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      required this.notChanged,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          )
        ],
      ),
    );
  }

  getImage() {
    if (imagePath.isEmpty && notChanged) {
      return AssetImage('assets/logo/unknown.png');
    } else if (!notChanged) {
      return FileImage(image!);
    } else {
      return NetworkImage(imagePath);
    }
  }

  Widget buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: getImage(),
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          color: color,
          padding: EdgeInsets.all(all),
          child: child,
        ),
      );
}
