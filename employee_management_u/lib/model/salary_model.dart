class SalaryData {
  bool? success;
  List<Data>? data;
  String? actualSallary;

  SalaryData({this.success, this.data, this.actualSallary});

  SalaryData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    actualSallary = json['ActualSallary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['ActualSallary'] = this.actualSallary;
    return data;
  }
}

class Data {
  String? monthYear;
  Counts? counts;

  Data({this.monthYear, this.counts});

  Data.fromJson(Map<String, dynamic> json) {
    monthYear = json['monthYear'];
    counts =
        json['counts'] != null ? new Counts.fromJson(json['counts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monthYear'] = this.monthYear;
    if (this.counts != null) {
      data['counts'] = this.counts!.toJson();
    }
    return data;
  }
}

class Counts {
  int? present;
  int? leave;
  int? holiday;
  int? sunday;
  int? totalDays;
  double? getSallary;

  Counts(
      {this.present,
      this.leave,
      this.holiday,
      this.sunday,
      this.totalDays,
      this.getSallary});

  Counts.fromJson(Map<String, dynamic> json) {
    present = json['Present'];
    leave = json['Leave'];
    holiday = json['Holiday'];
    sunday = json['Sunday'];
    totalDays = json['TotalDays'];
    getSallary = json['GetSallary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Present'] = this.present;
    data['Leave'] = this.leave;
    data['Holiday'] = this.holiday;
    data['Sunday'] = this.sunday;
    data['TotalDays'] = this.totalDays;
    data['GetSallary'] = this.getSallary;
    return data;
  }
}
