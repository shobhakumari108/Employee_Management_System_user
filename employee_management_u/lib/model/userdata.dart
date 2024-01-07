class UserData {
  String? email;
  String? password;
  String? token;
  String? firstName;
  String? lastName;
  String? id;
  String? companyEmployeeID;
  String? managerID;
  DateTime? joiningDate;
  List<String>? certificates;
  String? profilePhoto;
  String? jobTitle;
  String? mobileNumber;
  String? companyName;
  String? address;
  String? department;
  String? education;
  String? employmentStatus;
  String? workSchedule;
   String? salary;

  UserData({
    this.email,
    this.password,
    this.token,
    this.firstName,
    this.lastName,
    this.id,
    this.companyEmployeeID,
    this.managerID,
     this.joiningDate,
    this.certificates,
    this.profilePhoto,
    this.jobTitle,
    this.mobileNumber,
    this.companyName,
    this.address,
    this.department,
    this.education,
    this.employmentStatus,
    this.workSchedule,
    this.salary
  });

  UserData.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      email = json['Email']??"";
      password = json['Password']??"";
      token = json['token']??"";
      firstName = json['FirstName']??"";
      lastName = json['LastName']??"";
      id = json['id']??"";
      companyEmployeeID = json['ComapnyEmplyeeID']??"";
      managerID = json['ManagerId']??"";
      joiningDate = json['JoiningDate']==null?DateTime.now():DateTime.parse(json['JoiningDate']);
      certificates = List<String>.from(json['Certificates']??[""]);
      profilePhoto = json['ProfilePhoto']??"";
      jobTitle = json['JobTitle']??"";
      mobileNumber = json['MoblieNumber']??"";
      companyName = json['CompanyName']??"";
      address = json['Address']??"";
      department = json['Department']??"";
      education = json['Education']??"";
      employmentStatus = json['EmploymentStatus']??"";
      workSchedule = json['WorkSedule']??"";
      salary = json['Salary'] ?? "";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = {
      'Email': email,
      'Password': password,
      'FirstName': firstName,
      'LastName': lastName,
      'id': id,
      'ComapnyEmplyeeID': companyEmployeeID,
      'ManagerId': managerID,
      // 'JoiningDate': joiningDate,
      'Certificates': certificates,
      'ProfilePhoto': profilePhoto,
      'JobTitle': jobTitle,
      'MoblieNumber': mobileNumber,
      'CompanyName': companyName,
      'Address': address,
      'Department': department,
      'Education': education,
      'EmploymentStatus': employmentStatus,
      'WorkSedule': workSchedule,
      'token': token,
       'Salary': salary
    };
    // data['token'] = token;
    return data;
  }
}

// class UserData {
//   String email;
//   String password;
//   String token;
//   String firstName;
//   String lastName;
//   String id;
//   String companyEmployeeID;
//   String managerID;
//   DateTime joiningDate;
//   List<String> certificates;
//   String profilePhoto;
//   String jobTitle;
//   String mobileNumber;
//   String companyName;
//   String address;
//   String department;
//   String education;
//   String employmentStatus;
//   String workSchedule;

//   UserData({
//     required this.email,
//     required this.password,
//     required this.token,
//     required this.firstName,
//     required this.lastName,
//     required this.id,
//     required this.companyEmployeeID,
//     required this.managerID,
//      required this.joiningDate,
//     required this.certificates,
//     required this.profilePhoto,
//     required this.jobTitle,
//     required this.mobileNumber,
//     required this.companyName,
//     required this.address,
//     required this.department,
//     required this.education,
//     required this.employmentStatus,
//     required this.workSchedule,
//   });

//   UserData.fromJson(Map<String, dynamic> json) {
//     if (json != null) {
//       email = json['Email']??"";
//       password = json['Password']??"";
//       token = json['token']??"";
//       firstName = json['FirstName']??"";
//       lastName = json['LastName']??"";
//       id = json['id']??"";
//       companyEmployeeID = json['ComapnyEmplyeeID']??"";
//       managerID = json['ManagerId']??"";
//       joiningDate = json['JoiningDate']==null?DateTime.now():DateTime.parse(json['JoiningDate']);
//       certificates = List<String>.from(json['Certificates']??[""]);
//       profilePhoto = json['ProfilePhoto']??"";
//       jobTitle = json['JobTitle']??"";
//       mobileNumber = json['MoblieNumber']??"";
//       companyName = json['CompanyName']??"";
//       address = json['Address']??"";
//       department = json['Department']??"";
//       education = json['Education']??"";
//       employmentStatus = json['EmploymentStatus']??"";
//       workSchedule = json['WorkSedule']??"";
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user'] = {
//       'Email': email,
//       'Password': password,
//       'FirstName': firstName,
//       'LastName': lastName,
//       'id': id,
//       'ComapnyEmplyeeID': companyEmployeeID,
//       'ManagerId': managerID,
//       // 'JoiningDate': joiningDate,
//       'Certificates': certificates,
//       'ProfilePhoto': profilePhoto,
//       'JobTitle': jobTitle,
//       'MoblieNumber': mobileNumber,
//       'CompanyName': companyName,
//       'Address': address,
//       'Department': department,
//       'Education': education,
//       'EmploymentStatus': employmentStatus,
//       'WorkSedule': workSchedule,
//       'token': token
//     };
//     // data['token'] = token;
//     return data;
//   }
// }
