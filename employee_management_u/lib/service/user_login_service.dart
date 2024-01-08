// auth_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:employee_management_u/main.dart';
import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl = "https://employee-management-u6y6.onrender.com/app/users/login";

  static Future<UserData?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'Email': email, 'Password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Response Body: ${response.body}');
      await SharedPreferences.getInstance().then((value) {
        value.setString("token", responseData["user"]["token"]);
        value.setString("userId", responseData["user"]["id"]);
      });

      // Assuming UserLogin.fromJson is a factory constructor in your model class
      return UserData.fromJson(responseData["user"]); // Adjust this line
    } else {
      print("Error ${response.statusCode}: ${response.reasonPhrase}");
      print("Response Body: ${response.body}");
      return null;
    }
  }
//////////////////////////////////////////////

//  static const String apiUrl = "http://192.168.29.135:2000/app/users/updateByUser/${user.id}";
Future<UserData?> updateProfile(String sid, String mobilenumber,
      File? profilepicture, BuildContext context) async {
    final shared = await SharedPreferences.getInstance();
    final token = shared.getString("token");

    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('PUT', Uri.parse("https://employee-management-u6y6.onrender.com/app/users/updateByUser/${sid}"));
    request.fields.addAll({
      'MoblieNumber': mobilenumber,
    });
    if (profilepicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'ProfilePhoto', profilepicture.path));
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final jsondata = jsonDecode(data);
      print(jsondata);

      showToast("Profile update successfully", Colors.black);
      return UserData.fromJson(jsondata["data"]);
    } else {
      showToast(response.reasonPhrase, Colors.black);
      return null;
    }
  }
  ////////////////////////////////////////

 /* static Future<bool> updateProfile(UserData user, context, File? pImage, BuildContext context) async {
    var headers = {
'Authorization': 'Bearer ${user.token}'
};
var request = http.MultipartRequest('PUT', Uri.parse('http://192.168.29.135:2000/app/users/updateByUser/${user.id}'));
request.fields.addAll({
  'MoblieNumber': user.mobileNumber!,
});
request.files.add(await http.MultipartFile.fromPath('ProfilePhoto', user.profilePhoto!));
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
  
  return true;
}
else {
  print(response.reasonPhrase);
  return false;
}

  }

  static bool _isImageUrl(String? path) {
    // Add your logic to determine if the path is a URL or a local file path
    // For simplicity, let's assume it's a URL if it starts with 'http' or 'https'
    return path != null &&
        (path.startsWith('http://') || path.startsWith('https://'));
  }
*/
//===========================




//========================
  Future<bool> getUserData(token, userID, context) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET',
        Uri.parse('https://employee-management-u6y6.onrender.com/app/users/getUserById/$userID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();

      final jsondata = jsonDecode(data);
      UserData userData = UserData.fromJson(jsondata["data"]);
      Provider.of<UserProvider>(context, listen: false).setUser(userData);

      return true;
    } else {
      showToast(response.reasonPhrase, Colors.black);
      return false;
    }
  }

  
  ///======================log out
  
  Future<bool> logout(BuildContext context) async {
  final shared = await SharedPreferences.getInstance();
  final token = shared.getString("token");

  var headers = {'Authorization': 'Bearer $token'};
  var request = http.Request(
    'POST', // Change the HTTP method to POST
    Uri.parse('https://employee-management-u6y6.onrender.com/app/users/logout'),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Clear user-related data from SharedPreferences upon successful logout
    await shared.clear();

    // Navigate to the login screen
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => UserLoginScreen()),
    // );

    return true;
  } else {
    showToast(response.reasonPhrase, Colors.black);
    return false;
  }
}

  
  ///===========================
}
