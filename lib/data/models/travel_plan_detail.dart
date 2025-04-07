class TravelPlanDetail {
  int id;
  String employeeId;
  String code;
  String fullName;
  String costCenter;
  String department;
  String referenceNo;
  String transportMode;
  String workPlace;
  String travelType;
  String purpose;
  String currency;
  String travelStartDate;
  String travelEndDate;
  String description;
  String airTicket;
  int airTicketAmount;
  String hotelAccommodation;
  int hotelAccommodationAmount;
  String transport;
  int transportAmount;
  String dailyAllowance;
  int dailyAllowanceAmount;
  String transferAllowance;
  String mealAllowance;
  int mealAllowanceAmount;
  String guestHouseAccommodation;
  int advancePayment;
  List<Traveller> traveller;
  List<TravelPlanAuthorities> travelPlanAuthorities;
  List<TravelDestinations> travelDestinations;
  String travelPlanStatus;
  bool inProgressAuthority;

  String paymentMethod;
  String accountName;
  String accountNumber;
  String bankName;
  String bankAccountName;
  String bankAccountNumber;
  String branchName;
  String routingNo;
  String applicableCostCenter;

  TravelPlanDetail(
      {this.id,
        this.employeeId,
        this.code,
        this.fullName,
        this.costCenter,
        this.department,
        this.referenceNo,
        this.transportMode,
        this.workPlace,
        this.travelType,
        this.purpose,
        this.currency,
        this.travelStartDate,
        this.travelEndDate,
        this.description,
        this.airTicket,
        this.airTicketAmount,
        this.hotelAccommodation,
        this.hotelAccommodationAmount,
        this.transport,
        this.transportAmount,
        this.dailyAllowance,
        this.dailyAllowanceAmount,
        this.transferAllowance,
        this.mealAllowance,
        this.mealAllowanceAmount,
        this.guestHouseAccommodation,
        this.advancePayment,
        this.traveller,
        this.travelPlanAuthorities,
        this.travelDestinations,
        this.travelPlanStatus,
        this.inProgressAuthority,
        this.paymentMethod,
        this.accountName,
        this.accountNumber,
        this.bankName,
        this.bankAccountName,
        this.bankAccountNumber,
        this.branchName,
        this.routingNo,
        this.applicableCostCenter
      });

  TravelPlanDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId= json['employee_id'].toString();
    code = json['code']?? '';
    fullName = json['full_name']??'';
    costCenter = json['cost_center']?? '';
    department = json['department']?? '';
    referenceNo = json['reference_no']?? '';
    transportMode = json['transport_mode']?? '';
    workPlace = json['work_place']?? '';
    travelType = json['travel_type']?? '';
    purpose = json['purpose']?? '';
    currency = json['currency']?? '';
    travelStartDate = json['travel_start_date']?? '';
    travelEndDate = json['travel_end_date']?? '';
    description = json['description']?? '';
    airTicket = json['air_ticket']??'';
    airTicketAmount=json['air_ticket_amount']??0;
    hotelAccommodation = json['hotel_accommodation']?? '';
    hotelAccommodationAmount =json['hotel_accommodation_amount']??0;
    transport = json['transport']?? '';
    transportAmount =json['transport_amount']??0;
    dailyAllowance = json['daily_allowance']?? '';
    dailyAllowanceAmount = json['daily_allowance_amount']??0;
    transferAllowance = json['transfer_allowance']?? '';
    mealAllowance = json['meal_allowance']?? '';
    mealAllowanceAmount = json['meal_allowance_amount']??0;
    guestHouseAccommodation = json['guest_house_accommodation']?? '';
    advancePayment = json['advance_payment']?? 0;;
    if (json['traveller'] != null) {
      traveller = new List<Traveller>();
      json['traveller'].forEach((v) {
        traveller.add(new Traveller.fromJson(v));
      });
    }
    if (json['travelPlanAuthorities'] != null) {
      travelPlanAuthorities = new List<TravelPlanAuthorities>();
      json['travelPlanAuthorities'].forEach((v) {
        travelPlanAuthorities.add(new TravelPlanAuthorities.fromJson(v));
      });
    }

    if (json['travelDestinations'] != null) {
      travelDestinations = new List<TravelDestinations>();
      json['travelDestinations'].forEach((v) {
        travelDestinations.add(new TravelDestinations.fromJson(v));
      });
    }

    travelPlanStatus = json['travel_plan_status']?? '';
    inProgressAuthority = json['in_progress_authority']?? false;

    paymentMethod = json['payment_method']??'N/A';
    accountName= json['account_name']??'N/A';
    accountNumber= json['account_number']??'N/A';
    bankName = json['bank_name']??'N/A';
    bankAccountName = json['bank_account_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
    branchName = json['branch_name']??'N/A';
    routingNo = json['routing_no']??'N/A';
    applicableCostCenter = json['applicable_cost_center']??'N/A';


  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['full_name'] = this.fullName;
    data['cost_center'] = this.costCenter;
    data['department'] = this.department;
    data['reference_no'] = this.referenceNo;
    data['transport_mode'] = this.transportMode;
    data['work_place'] = this.workPlace;
    data['travel_type'] = this.travelType;
    data['purpose'] = this.purpose;
    data['currency'] = this.currency;
    data['travel_start_date'] = this.travelStartDate;
    data['travel_end_date'] = this.travelEndDate;
    data['description'] = this.description;
    data['air_ticket'] = this.airTicket;
    data['hotel_accommodation'] = this.hotelAccommodation;
    data['transport'] = this.transport;
    data['daily_allowance'] = this.dailyAllowance;
    data['transfer_allowance'] = this.transferAllowance;
    data['meal_allowance'] = this.mealAllowance;
    data['guest_house_accommodation'] = this.guestHouseAccommodation;
    data['advance_payment'] = this.advancePayment;
    if (this.traveller != null) {
      data['traveller'] = this.traveller.map((v) => v.toJson()).toList();
    }
    if (this.travelPlanAuthorities != null) {
      data['travelPlanAuthorities'] =
          this.travelPlanAuthorities.map((v) => v.toJson()).toList();
    }
    data['travel_plan_status'] = this.travelPlanStatus;
    return data;
  }
}

class Traveller {
  String firstName;
  String middleName;
  String lastName;
  String code;

  Traveller({this.firstName, this.middleName, this.lastName, this.code});

  Traveller.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name']??'';
    middleName = json['middle_name']??'';
    lastName = json['last_name']??'';
    code = json['code']?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['code'] = this.code;
    return data;
  }
}

class TravelPlanAuthorities {
  String authorityName;
  int authorityOrder;
  String authorityStatus;
  String processedEmployee;
  String createdAt;
  String remarks;

  TravelPlanAuthorities(
      {this.authorityName,
        this.authorityOrder,
        this.authorityStatus,
        this.processedEmployee,
        this.createdAt,
        this.remarks});

  TravelPlanAuthorities.fromJson(Map<String, dynamic> json) {
    authorityName = json['authority_name'] ??'';
    authorityOrder = json['authority_order'];
    authorityStatus = json['authority_status'] ??'';
    processedEmployee = json['processed_employee'] ??'';
    createdAt = json['created_at'] ??'N/A';
    remarks = json['remarks'] ??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority_name'] = this.authorityName;
    data['authority_order'] = this.authorityOrder;
    data['authority_status'] = this.authorityStatus;
    data['processed_employee'] = this.processedEmployee;
    data['created_at'] = this.createdAt;
    data['remarks'] = this.remarks;
    return data;
  }
}

class TravelDestinations {
  String travelStart;
  String travelEnd;

  TravelDestinations({this.travelStart, this.travelEnd});

  TravelDestinations.fromJson(Map<String, dynamic> json) {
    travelStart = json['travel_start'];
    travelEnd = json['travel_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['travel_start'] = this.travelStart;
    data['travel_end'] = this.travelEnd;
    return data;
  }
}