// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razor_book/router-constants.dart';
import '../view_model/login_view_model.dart';
import '../helpers/helper_widgets.dart';
// import '../views/signup_view.dart';
// import '../views/forgot_password_view.dart';
// import '../views/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // locator<LoginViewModel>()

    // this is connecting to the view model which is provided globally through a multi-provider
    LoginViewModel model = context.watch<LoginViewModel>();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: const [
          Color.fromARGB(0, 219, 201, 201),
          Color.fromARGB(255, 21, 141, 91),
          Color(0x610BE803)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 15),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                SizedBox(
                  height: 20,
                ),
                inputField("Enter your Email", Icons.mail_outline, false,
                    emailController),
                SizedBox(
                  height: 20,
                ),
                inputField("Enter your Password", Icons.lock_outline, true,
                    passwordController),
                SizedBox(
                  height: 30,
                ),
                confirmButton(context, "Login", () async {
                  try {
                    print(
                        "current user before login is ${model.currentUser?.email}");
                    await model.signIn(
                        email: emailController.text,
                        password: passwordController.text);
                    // FORWARD TO PAGE HERE:

                    if (model.currentUser != null) {
                      print("current user is not null");
                      print("current user is ${model.currentUser?.email}");
                      print("current user is ${model.currentUser?.user_type}");
                      print("user_type: ${model.currentUser?.user_type}");
                      if (model.currentUser?.user_type == "barber") {
                        print("naving to barber");
                        Navigator.pushNamed(context, BarberMainNavRoute);
                      } else {
                        print("naving to customer");
                        Navigator.pushNamed(context, CustomerMainNavRoute);
                      }
                    }
                  } catch (e) {
                    String errorMessage = e.toString();
                    // setState(() {});
                    var snackBar = messageSnackBar(errorMessage, Colors.red);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ForgotPasswordRoute);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        // horizontal: 20,
                        vertical:
                            15), //apply padding horizontal or vertical only
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                signup(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.white)),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignupViewRoute);
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
