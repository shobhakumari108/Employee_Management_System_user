import 'dart:convert';
import 'dart:io';

import 'package:employee_management_u/model/salary_model.dart';
import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';
import 'package:employee_management_u/screen/edit_profile_screen.dart';
import 'package:employee_management_u/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class EmployeeProfileScreen extends StatefulWidget {
  // final UserData user;

  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late UserData userData;
  SalaryData? salaryData;
  double getSallary = 0;
  String actualSallary = 'Loading...';
  final dateFormatter = DateFormat('d MMMM, y');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userData = Provider.of<UserProvider>(context).userInformation!;
    fetchSalaryData();
  }

  Future<void> fetchSalaryData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://employee-management-u6y6.onrender.com/app/attendence/sallaryByUserId/${userData.id}'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(
            'API Response: $responseData'); // Print the API response for debugging
        final double getSallaryValue =
            responseData['data'][0]['counts']['GetSallary'];
        final String actualSallaryValue = responseData['ActualSallary'];

        setState(() {
          getSallary = getSallaryValue;
          actualSallary = 'Actual Salary: $actualSallaryValue';
        });
      } else {
        print(
            'Failed to load salary data. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching salary data: $e');
    }
  }

  // bool _isImageUrl(String path) {
  bool _isImageUrl(String path) {
    if (path == null || path.isEmpty) {
      return false;
    }

    Uri uri = Uri.parse(path);
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  Widget _buildProfileCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      /* child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // subtitle: title == 'certificates'
        //     ? Container(
        //         height: 100, // Adjust the height based on your design
        //         child: ListView.builder(
        //           scrollDirection: Axis.horizontal,
        //           itemCount: user.certificates?.length ?? 0,
        //           itemBuilder: (context, index) {
        //             return Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //               child: Image.network(
        //                 user.certificates?[index] ?? '',
        //                 height: 80,
        //                 width: 80,
        //                 errorBuilder: (BuildContext context, Object error,
        //                     StackTrace? stackTrace) {
        //                   return Text('Error loading certificate image');
        //                 },
        //               ),
        //             );
        //           },
        //         ),
        //       )
        //     : Text(
        //         value,
        //         style: const TextStyle(
        //           fontSize: 14,
        //           color: Colors.black87,
        //         ),
        //       ),

        subtitle: title == 'certificates'
            ? Container(
                height: 100, // Adjust the height based on your design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userData.certificates?.length ?? 0,
                  itemBuilder: (context, index) {
                    final certificate = userData.certificates?[index] ?? '';
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _isImageUrl(certificate)
                          ? Image.network(
                              certificate,
                              height: 80,
                              width: 80,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Text('Error loading certificate image');
                              },
                            )
                          : Image.file(
                              File(certificate),
                              height: 80,
                              width: 80,
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return Text('Error loading certificate image');
                              },
                            ),
                    );
                  },
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
      ),
   */
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Color.fromARGB(255, 61, 124, 251),
            ),
            onPressed: () {
              // Navigate to the edit screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: userData),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors
                      .blue[100], // Set background color for the CircleAvatar
                  child: userData.profilePhoto?.isNotEmpty == true
                      ? ClipOval(
                          child: Image.network(
                            userData.profilePhoto!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                          color: Color.fromARGB(255, 61, 124, 251),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${userData.firstName} ${userData.lastName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Achievement",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contact information",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      //  SizedBox(
                      //       height: 10,
                      //     ),
                      Text("Mobile number : ${userData.mobileNumber}"),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text("Email : ${userData.email} "),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Salary",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text('Payment: ₹ ${getSallary.toStringAsFixed(2)}'),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text('Actual salry : ₹ ${userData.salary}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "General information",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text('Job title : ${userData.jobTitle} '),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text(
                        // 'Joining date : ${userData.joiningDate}'
                        'Joining date : ${dateFormatter.format(DateTime.parse('${userData.joiningDate}'))}',
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text(
                        'Company name : ${userData.companyName}',
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text("Employee id : ${userData.companyEmployeeID} "),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text("Department : ${userData.department} "),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text("Employment status : ${userData.employmentStatus}"),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      Text("Maneger id : ${userData.managerID} "),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Additional information",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey[300],
                      ),
                      //  SizedBox(
                      //       height: 10,
                      //     ),
                      Text("Address :${userData.address} "),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
