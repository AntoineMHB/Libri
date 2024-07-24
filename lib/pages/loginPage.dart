import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libri/components/my_button.dart';
import 'package:libri/components/my_textfield.dart';
import 'package:libri/components/square_tile.dart';
import 'package:libri/services/auth_service.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;
  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Try sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Pop the loading circle
      Navigator.pop(context);
    } catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Show appropriate error message based on exception type
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          // User not found
          wrongEmailMessage();
        } else if (e.code == 'wrong-password') {
          // Wrong password
          wrongPasswordMessage();
        } else {
          // Handle other FirebaseAuthExceptions
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Sign In Error'),
                content: Text(e.message ?? 'Unknown error occurred'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle unexpected errors
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'An unexpected error occurred. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  // Wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Email'),
          content: const Text('The email address you entered does not exist.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Incorrect Password'),
          content: const Text('The password you entered is incorrect.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtil.blockSizeHorizontal * 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                // logo
                Icon(
                  Icons.lock,
                  size: ResponsiveUtil.blockSizeHorizontal * 20,
                  color: secondaryColor,
                ),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                // welcome back, you've been missing
                Text(
                  'Welcome back you\'ve been missed',
                  style: FontManager.bodyStyle.copyWith(
                    color: textColor.withOpacity(0.7),
                    fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
                  ),
                ),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 2.5),
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: ResponsiveUtil.blockSizeVertical),
                // password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                SizedBox(height: ResponsiveUtil.blockSizeVertical),

                // sign_in_button
                MyButton(
                  text: "Sign In",
                  onTap: signUserIn,
                ),

                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                _buildDivider(textColor),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                _buildSocialSignIn(),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
                _buildRegisterPrompt(textColor, secondaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtil.blockSizeHorizontal * 6),
      child: Row(children: [
        Expanded(
            child: Divider(thickness: 0.5, color: textColor.withOpacity(0.4))),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtil.blockSizeHorizontal * 2.5),
          child: Text(
            'Or continue with',
            style: FontManager.bodyStyle
                .copyWith(color: textColor.withOpacity(0.7)),
          ),
        ),
        Expanded(
            child: Divider(thickness: 0.5, color: textColor.withOpacity(0.4)))
      ]),
    );
  }

  Widget _buildSocialSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SquareTile(
          onTap: () => AuthService().signInWithGoogle(),
          imagePath: 'lib/images/google_logo.png',
        ),
        SizedBox(width: ResponsiveUtil.blockSizeHorizontal * 6),
        SquareTile(imagePath: 'lib/images/apple_logo.png'),
      ],
    );
  }

  Widget _buildRegisterPrompt(Color textColor, Color secondaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not a member?',
          style:
              FontManager.bodyStyle.copyWith(color: textColor.withOpacity(0.7)),
        ),
        SizedBox(width: ResponsiveUtil.blockSizeHorizontal),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            'Register now',
            style: FontManager.bodyStyle.copyWith(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
