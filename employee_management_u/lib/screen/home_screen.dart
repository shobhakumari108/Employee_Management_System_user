import 'dart:convert';

import 'package:employee_management_u/auth/login_screen.dart';
import 'package:employee_management_u/model/userdata.dart';
import 'package:employee_management_u/provider/userProvider.dart';

import 'package:employee_management_u/screen/current_location_screen.dart';
import 'package:employee_management_u/screen/daily_work_summary.dart';
import 'package:employee_management_u/service/shared_pref.dart';
import 'package:employee_management_u/utils/toaster.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  // final UserData user;

  const HomeScreen({
    super.key,
  });
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserData userData;
  late Future<List<Map<String, dynamic>>> holidaysFuture;

  List<Map<String, dynamic>> holidays = [];
  final dateFormatter = DateFormat('d MMMM, y');

  @override
  // void initState() {
  //   super.initState();
  //   userData = Provider.of<UserProvider>(context).userInformation;
  //   holidaysFuture = fetchData();
  // }
  void didChangeDependencies() {
    super.didChangeDependencies();

    userData = Provider.of<UserProvider>(context).userInformation!;
    holidaysFuture =
        fetchAndDisplayHolidays(); // Uncomment and assign the Future
  }

  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Ensure that userInformation is not null before accessing its properties
  //   if (Provider.of<UserProvider>(context).userInformation != null) {
  //     userData = Provider.of<UserProvider>(context).userInformation!;
  //     holidaysFuture = fetchAndDisplayHolidays();
  //   }
  // }

//===============logout
// ...

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform additional cleanup actions if needed

                // Clear SharedPreferences
                final sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.clear();
                // Provider.of<UserProvider>(context, listen: false)
                // .setUser(userData);

                // Reset the application state if needed

                // Provider.of<UserProvider>(context, listen: false).setUser(null);
                //  Provider.of<UserProvider>(context, listen: false)
                // .setUser(userData);

                // Navigate to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginScreen()),
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

// ...

//===============================
  // Future<void> logout(BuildContext context) async {
  //   try {
  //     // Perform additional cleanup actions if needed

  //     // Clear SharedPreferences
  //     final sharedPreferences = await SharedPreferences.getInstance();
  //     await sharedPreferences.clear();

  //     // Reset the application state if needed

  //     // Navigate to the login screen
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => UserLoginScreen()),
  //       (route) => false,
  //     );
  //   } catch (e) {
  //     // Handle any errors during logout
  //     print('Error during logout: $e');
  //   }
  // }

  // Future<void> logout(BuildContext context) async {
  //   try {
  //     final shared = await SharedPreferences.getInstance();
  //     final token = shared.getString("token");

  //     var headers = {'Authorization': 'Bearer $token'};
  //     var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           'https://employee-management-u6y6.onrender.com/app/users/logout'),
  //     );

  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Clear user-related data from SharedPreferences upon successful logout
  //       await shared.clear();

  //       // Navigate to the login screen
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => UserLoginScreen()),
  //         (route) => false,
  //       );
  //     } else {
  //       showToast(response.reasonPhrase, Colors.black);
  //     }
  //   } catch (e) {
  //     // Handle any errors during logout
  //     print('Error during logout: $e');
  //   }
  // }

  Future<List<Map<String, dynamic>>> fetchAndDisplayHolidays() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://employee-management-u6y6.onrender.com/app/holiday/getHoliday'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        List<Map<String, dynamic>> fetchedHolidays =
            List<Map<String, dynamic>>.from(responseData['data']);
        return fetchedHolidays;
      } else {
        print(
            'Failed to fetch holiday data. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return []; // Return an empty list in case of failure
      }
    } catch (e) {
      print("============");
      print('Error fetching holiday data: $e');
      return []; // Return an empty list in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print("=====home==token==${userData.token}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee management System'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 61, 124, 251),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Shobha Kumari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'shobha@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                // Handle the app lock action
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the App'),
              onTap: () {
                // Handle the rating action
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share with Friends'),
              onTap: () {
                // Handle the sharing action
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Text(userData.id!),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrentLocationScreen(),
                          ),
                        );

                        // Handle the first button action
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        primary: const Color.fromARGB(255, 61, 124, 251),
                        fixedSize: Size(size.width / 2 - 35, 50),
                      ),
                      child: const Text(
                        'IN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailySummaryScreen(),
                          ),
                        );

                        // Handle the second button action
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        primary: const Color.fromARGB(255, 61, 124, 251),
                        fixedSize: Size(size.width / 2 - 35, 50),
                      ),
                      child: const Text(
                        'OUT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                // TextButton(onPressed: ()async{
                //   await SharedPreferences.getInstance().then((value) {
                //     print("====shared token==${value.getString("token")}");
                //     print("====shared id==${value.getString("userId")}");

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: holidaysFuture, // Use the Future you defined
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Map<String, dynamic>> holidays = snapshot.data ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Holidays',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display holidays
                          Column(
                            children: holidays.map((holiday) {
                              String name = holiday['holiday'];
                              // String date = holiday['holiDate'];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 226, 226, 226),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                                '${dateFormatter.format(DateTime.parse(holiday['holiDate']))}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
