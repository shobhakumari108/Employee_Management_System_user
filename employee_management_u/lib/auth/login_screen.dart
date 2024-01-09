// user_login_screen.dart

// import 'package:employee_management_u/model/user_login_get_model.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:employee_management_u/service/user_login_service.dart';
import 'package:employee_management_u/utils/navigator.dart';
import 'package:employee_management_u/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService = AuthService();
  // void _navigateToHomeScreen(BuildContext context) {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => MyHomePage()),
  //   );
  // }

  // void _navigateToUserDetailsScreen(BuildContext context, UserLoginGet user) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => UserDetailsScreen(user: user)),
  //   );
  // }

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
                  onPressed: () async {
                    await authService
                        .login(_emailController.text, _passwordController.text,
                            context)
                        .then((value) {
                      if (value) {
                        removeAllAndPush(context, const MyHomePage());
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the radius as needed
                    ),
                    primary: const Color.fromARGB(255, 61, 124, 251),
                  ),
                  child: const Text(
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
