import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_app/resources/auth_methods.dart';
import 'package:social_app/responsive/mobile_screen_layout.dart';
import 'package:social_app/responsive/responsive_layout_screen.dart';
import 'package:social_app/responsive/web_screen_layout.dart';
import 'package:social_app/screens/signup_screen.dart';
import 'package:social_app/utils/colors.dart';
import 'package:social_app/utils/utils.dart';
import 'package:social_app/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ResponsiveLayout(
          webScreenLayout: const WebScreenLayout(),
          mobileScreenLayout: const MobileScreenLayout(),
        ),
      ));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: loginUser,
                      child: const Text(
                        'Log In',
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
                    child: const Text('Don\'t have an account ?!'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen()));
                    },
                    child: Container(
                      child: const Text(
                        'SignUp',
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
    );
  }
}
