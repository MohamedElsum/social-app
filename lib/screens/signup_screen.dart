import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout_screen.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/utils/utils.dart';
import 'package:social_app/widgets/text_field_input.dart';
import 'dart:io';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  File? loadedImage;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    File? im = await pickImage(ImageSource.gallery);
    setState(() {
      loadedImage = im;
    });
  }

  void signup() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: emailController.text,
        bio: bioController.text,
        password: passwordController.text,
        username: userNameController.text,
        file: loadedImage);

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
          webScreenLayout: const WebScreenLayout(),
          mobileScreenLayout: const MobileScreenLayout(),
        ),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/ic_instagram.svg',
                  color: primaryColor,
                  height: 64.0,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 70.0,
                      backgroundImage: loadedImage == null
                          ? NetworkImage(
                              'https://www.pngarts.com/files/10/Default-Profile-Picture-Transparent-Image.png')
                          : FileImage(loadedImage!) as ImageProvider,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: selectImage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFieldInput(
                    controller: userNameController,
                    hintText: 'Enter Your Username ',
                    textInput: TextInputType.text),
                const SizedBox(
                  height: 25.0,
                ),
                TextFieldInput(
                    controller: emailController,
                    hintText: 'Enter Your Email ',
                    textInput: TextInputType.emailAddress),
                const SizedBox(
                  height: 25.0,
                ),
                TextFieldInput(
                    controller: passwordController,
                    isPass: true,
                    hintText: 'Enter Your Password',
                    textInput: TextInputType.text),
                const SizedBox(
                  height: 25.0,
                ),
                TextFieldInput(
                    controller: bioController,
                    hintText: 'Enter Your Bio ',
                    textInput: TextInputType.text),
                const SizedBox(
                  height: 25.0,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: signup,
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: Size(double.infinity, 50.0),
                        ),
                      ),
                const SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('You already have an account ?'),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Container(
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
