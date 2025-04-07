import 'package:recom_app/data/models/key_value_pair.dart';

class LunchSubscriptionRequest {
  String employeeCode;
  String employeeName;
  String employeeRole;
  String subscriptionDate;
  String subscriptionRequestTimeLine;
  String perMeal;
  List<OfficeLocation> officeLocation;
  Food food;

  LunchSubscriptionRequest(
      {this.employeeCode,
        this.employeeName,
        this.employeeRole,
        this.subscriptionDate,
        this.officeLocation,this.perMeal,this.subscriptionRequestTimeLine,this.food});

  LunchSubscriptionRequest.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employee_code']??'N/A';
    employeeName = json['employee_name']??'N/A';
    employeeRole = json['employee_role']??'N/A';
    subscriptionDate = json['subscription_date']??'N/A';
    perMeal = json['per_meal']??'N/A';
    subscriptionRequestTimeLine = json['subscription_request_time_line']??'04:00:00 PM';

    if (json['office_location'] != null) {
      officeLocation = <OfficeLocation>[];
      json['office_location'].forEach((v) {
        officeLocation.add(new OfficeLocation.fromJson(v));
      });
    }

    food = json['food'] != null ?  Food.fromJson(json['food']) : Food(foodList: []);
  }
}

class Food {
  List<KeyValuePair> foodList=<KeyValuePair>[];

  Food({this.foodList});

  Food.fromJson(Map<String, dynamic> json) {
      json.forEach((key, value) {
        foodList.add(KeyValuePair(id: key.trim(),name: value.trim() ));
      });
  }
}

class OfficeLocation {
  int id;
  String name;
  String address;
  List<Floors> floors;

  OfficeLocation({this.id, this.name, this.address, this.floors});

  OfficeLocation.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'N/A';
    address = json['address']??'N/A';
    if (json['floors'] != null) {
      floors = <Floors>[];
      json['floors'].forEach((v) {
        floors.add(new Floors.fromJson(v));
      });
    }
  }
}

class Floors {
  int id;
  String name;
  int officeLocationId;
  int status;
  String remarks;
  int createdBy;
  String updatedBy;
  String createdAt;
  String updatedAt;

  Floors(
      {this.id,
        this.name,
        this.officeLocationId,
        this.status,
        this.remarks,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt});

  Floors.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    name = json['name']??'N/A';
    officeLocationId = json['office_location_id']??0;
    status = json['status']??'N/A';
    remarks = json['remarks']??'N/A';
    createdBy = json['created_by']??'N/A';
    updatedBy = json['updated_by']??'N/A';
    createdAt = json['created_at']??'N/A';
    updatedAt = json['updated_at']??'N/A';
  }
}