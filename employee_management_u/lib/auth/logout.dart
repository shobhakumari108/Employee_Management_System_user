import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LogoutScreen extends StatelessWidget {
  Future<void> logout() async {
    // Replace the URL with your logout API endpoint
    const String logoutUrl = 'http://localhost:2000/app/users/logout';

    try {
      final response = await http.post(Uri.parse(logoutUrl));

      if (response.statusCode == 200) {
        // Successful logout
        print('Logout successful');
        // Navigate to the login screen or perform other actions as needed
      } else {
        // Handle error case
        print('Failed to logout. ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle exception
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logout();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
