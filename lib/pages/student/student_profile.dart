import 'package:flutter/material.dart';
import 'package:padvisor/pages/sign_in.dart';
import 'package:padvisor/shared/color_constant.dart';
import 'package:padvisor/shared/user.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final User = UserPreferences.myUser;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/logo/logo_white.png'),
        ),
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: 375,
        height: 660,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 15,
              ),
              ProfileWidget(
                imagePath: User.imagePath,
                onClicked: () async {},
              ),
              const SizedBox(
                height: 24,
              ),
              buildTextField("Full Name", User.name, false),
              const SizedBox(height: 10),
              buildTextField("Matric Number", User.matricno, false),
              const SizedBox(height: 10),
              buildTextField("Email", User.email, false),
              const SizedBox(height: 10),
              buildTextField("Password", User.password, true),
              const SizedBox(height: 10),
              buildTextField("WhatsApp", User.whatsapp, false),
              const SizedBox(height: 10),
              buildTextField("WeChat", User.wechat, false),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.tertiaryColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Saved',
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

  TextField buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return TextField(
      obscureText: isPasswordTextField ? showPassword : false,
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
        hintText: placeholder,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key, required this.imagePath, required this.onClicked})
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

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
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
