import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nymble_music_app/src/presentation/providers/theme_provider.dart';
import 'package:nymble_music_app/src/presentation/views/views.dart';
import 'package:nymble_music_app/src/presentation/widgets/text_form_filed.dart';
import 'package:nymble_music_app/src/utils/resources/auth.dart';
import 'package:nymble_music_app/src/utils/resources/scaffold_messenger.dart';
import 'package:provider/provider.dart';

import '../../widgets/button.dart';

class Login extends StatefulWidget {
  static const String name = "login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = true;
  bool isBusy = false;
  bool isSignUp = false;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  toggleIsPasswordVisible() {
    if (mounted) {
      HapticFeedback.heavyImpact();
      setState(() {
        isPasswordVisible = !isPasswordVisible;
      });
    }
  }

  toggleIsSignUp() {
    if (mounted) {
      HapticFeedback.heavyImpact();
      setState(() {
        isSignUp = !isSignUp;
      });
    }
  }

  toggleIsBusy() {
    if (mounted) {
      setState(() {
        isBusy = !isBusy;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                        Color(0xff0059DD),
                        BlendMode.color,
                      ),
                      image: CachedNetworkImageProvider(
                          "https://hotelzify-prod-images-bucket.s3.ap-south-1.amazonaws.com/441017ca-5d51-4a89-bde4-107e5e5ca173.png"),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                        color: Theme.of(context).hoverColor,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .changeAppThemeMode();
                        },
                        icon: Provider.of<ThemeProvider>(context, listen: false)
                                .isDark
                            ? const Icon(
                                Icons.sunny,
                              )
                            : const Icon(
                                FontAwesomeIcons.moon,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              height: MediaQuery.sizeOf(context).height,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      isSignUp ? "Welcome!" : "Hello Again!",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      isSignUp
                          ? "Ready to explore top charts? Register now and start discovering!"
                          : "It's great to have you back! Please login to access your account",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AppTextFormField(
                      controller: emailController,
                      name: "email",
                      perfixIcon: Icons.email_outlined,
                    ),
                    AppTextFormField(
                      controller: passwordController,
                      name: "password",
                      perfixIcon: Icons.lock_outline_rounded,
                      suffixIcon: isPasswordVisible
                          ? Icons.remove_red_eye_outlined
                          : Icons.password,
                      obscureText: isPasswordVisible,
                      onSuffixIconTap: toggleIsPasswordVisible,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AppButton(
                      name: isSignUp ? "Sign Up" : "Log In",
                      minWidth: MediaQuery.sizeOf(context).width,
                      isLoading: isBusy,
                      onPressed: () async {
                        // context.pushNamed(Home.name);
                        // return;
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          Messenger(context).showSnackBar(
                              "Enter email and password to proceed");
                          return;
                        }

                        toggleIsBusy();

                        final message = isSignUp
                            ? await AuthService.registration(
                                email: emailController.text,
                                password: passwordController.text,
                              )
                            : await AuthService.login(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                        toggleIsBusy();

                        if (context.mounted) {
                          if (message?.contains('Success') ?? false) {
                            emailController.clear();
                            passwordController.clear();
                            context.goNamed(Home.name);
                          }
                          Messenger(context).showSnackBar(
                              message ?? "Something went wrong, try again");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: isSignUp
                              ? "Already have an account?  "
                              : 'Are you new here?  ',
                          style: Theme.of(context).textTheme.displaySmall,
                          children: <TextSpan>[
                            TextSpan(
                              text: isSignUp ? "Log In" : 'Sign Up',
                              style: const TextStyle(
                                color: Color(0xff0059DD),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = toggleIsSignUp,
                            ),
                          ],
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
    );
  }
}
