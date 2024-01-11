import 'package:employee_management_u/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:employee_management_u/service/user_login_service.dart';
import 'package:employee_management_u/utils/navigator.dart';
import 'package:employee_management_u/widgets/textfield.dart';
import 'package:lottie/lottie.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool _isLoggingIn = false; // Added to track login status

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Lottie.asset(
                'assets/Animation - 1703759522611.json',
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 61, 124, 251),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildTextFieldWithIcon(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildTextFieldWithIcon(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoggingIn
                      ? null
                      : () async {
                          // Set login status to true
                          setState(() {
                            _isLoggingIn = true;
                          });

                          await authService
                              .login(_emailController.text,
                                  _passwordController.text, context)
                              .then((value) {
                            if (value) {
                             Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyHomePage(),
                                ),
                                (route) => false,
                              );
                            }
                          }).whenComplete(() {
                            // Set login status to false when completed
                            setState(() {
                              _isLoggingIn = false;
                            });
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                    primary: const Color.fromARGB(255, 61, 124, 251),
                  ),
                  child: _isLoggingIn
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 61, 124, 251),
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
