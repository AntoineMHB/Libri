import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libri/components/my_button.dart';
import 'package:libri/components/my_textfield.dart';
import 'package:libri/components/square_tile.dart';
import 'package:libri/services/auth_service.dart';
import 'package:libri/themes/color_schemes.dart';
import 'package:libri/utils/font_manager.dart';
import 'package:libri/utils/responsive_util.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback? onTap;

  RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating the user
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Optionally, navigate to another page or show a success message
      } else {
        // show error message, passwords don't match
        showErrorMessage("Passwords don't match");
      }
    } catch (e) {
      // Pop the loading circle
      Navigator.pop(context);

      // Handle exceptions
      if (e is FirebaseAuthException) {
        // Show error message based on exception type
        showErrorMessage(e.message ?? 'An error occurred');
      } else {
        // Handle unexpected errors
        showErrorMessage(
            'An unexpected error occurred. Please try again later.');
      }
    } finally {
      // Make sure the loading dialog is always dismissed
      Navigator.pop(context);
    }
  }

  // show error message
  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
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

                // let's create an account for you
                Text('Let\'s create an account for you!',
                    style: FontManager.bodyStyle.copyWith(
                      color: textColor.withOpacity(0.7),
                      fontSize: ResponsiveUtil.blockSizeHorizontal * 4,
                    )),

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

                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                SizedBox(height: ResponsiveUtil.blockSizeVertical),

                // forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: FontManager.bodyStyle.copyWith(
                      color: textColor.withOpacity(0.6),
                      fontSize: ResponsiveUtil.blockSizeHorizontal * 3.5,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtil.blockSizeVertical),

                // sign_up_button
                MyButton(
                  text: "Sign Up",
                  onTap: signUserUp,
                ),

                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                _buildDivider(textColor),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 5),
                _buildSocialSignIn(),
                SizedBox(height: ResponsiveUtil.blockSizeVertical * 2),
                _buildLoginPrompt(textColor, secondaryColor),
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

  Widget _buildLoginPrompt(Color textColor, Color secondaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style:
              FontManager.bodyStyle.copyWith(color: textColor.withOpacity(0.7)),
        ),
        SizedBox(width: ResponsiveUtil.blockSizeHorizontal),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            'Login now',
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
