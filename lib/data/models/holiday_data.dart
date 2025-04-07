import 'package:intl/intl.dart';

import '../../services/helper/date_services.dart';
class HolidayData {
  //List<Holiday> holiday;
  var holiday = <Holiday>[];
  HolidayData({this.holiday});

  HolidayData.fromJson(Map<String, dynamic> json) {
    if (json['holiday'] != null && json['holiday'] is List) {
      holiday = <Holiday>[]; //new List<Holiday>();
      json['holiday'].forEach((v) {
        holiday.add(new Holiday.fromJson(v));
      });
    } else {
      holiday = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.holiday != null) {
      data['holiday'] = this.holiday.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Holiday {
  String date;
  String day;
  String reason;
  String note;
  String countryCode;

  Holiday({this.date, this.day, this.reason,this.note,this.countryCode});

  Holiday.fromJson(Map<String, dynamic> json) {
    date = json['holiday_date'];

    DateService dateService = new DateService();

    var holiday_date = dateService.getDateFromDDMMMYYYY(json['holiday_date'].toString());
    //Getting Name of the day
    day =(DateFormat('EEEE').format(holiday_date));
    reason = json['name'];
    note = json['note'];
    countryCode = json['country_code']??'BD';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holiday_date'] = this.date;
    data['Day'] =  this.day;
    data['name'] = this.reason;
    data['note'] = this.note;

    return data;
  }
}
