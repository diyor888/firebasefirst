import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirst/pages/home_page.dart';
import 'package:firebasefirst/pages/signin_page.dart';
import 'package:firebasefirst/services/auth_service.dart';
import 'package:firebasefirst/services/preference_service.dart';
import 'package:firebasefirst/services/toast_service.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_up_page';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp() {
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    setState(() {
      isLoading = true;
    });

    AuthService.signUpUser(context, name, email, password)
        .then((firebaseUser) => {
              _getFirebaseUser(firebaseUser!),
            });
  }

  _getFirebaseUser(User firebaseUser) async {
    if (firebaseUser != null) {
      setState(() {
        isLoading = false;
      });
      await Preference.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      ToastService.fireToast("Check your informations!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullnameController,
                  decoration: InputDecoration(
                    hintText: 'Full name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  //obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  color: Colors.blue,
                  height: 45,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _doSignUp();
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign in",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
