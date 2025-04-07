class SettlementRequestDetail {
  int id;
  int employeeId;
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
  String hotelAccommodation;
  String transport;
  String dailyAllowance;
  String transferAllowance;
  String mealAllowance;
  String guestHouseAccommodation;
  int advancePayment;
  List<Traveller> traveller;
  List<TravelDestinations> travelDestinations;
  List<TravelPlanAuthorities> travelPlanAuthorities;
  String travelPlanStatus;
  bool inProgressAuthority;
  SRDTravelSettlement travelSettlement;
  List<TravelSettlementAuthority> travelSettlementAuthority;


  SettlementRequestDetail(
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
        this.hotelAccommodation,
        this.transport,
        this.dailyAllowance,
        this.transferAllowance,
        this.mealAllowance,
        this.guestHouseAccommodation,
        this.advancePayment,
        this.traveller,
        this.travelDestinations,
        this.travelPlanAuthorities,
        this.travelPlanStatus,
        this.inProgressAuthority,
        this.travelSettlement,
        this.travelSettlementAuthority});

  SettlementRequestDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    code = json['code'] ??'';
    fullName = json['full_name'] ??'';
    costCenter = json['cost_center']??'';
    department = json['department']??'';
    referenceNo = json['reference_no']??'';
    transportMode = json['transport_mode']??'';
    workPlace = json['work_place']??'';
    travelType = json['travel_type']??'';
    purpose = json['purpose']??'';
    currency = json['currency']??'';
    travelStartDate = json['travel_start_date']??'';
    travelEndDate = json['travel_end_date']??'';
    description = json['description']??'';
    airTicket = json['air_ticket'];
    hotelAccommodation = json['hotel_accommodation'];
    transport = json['transport'];
    dailyAllowance = json['daily_allowance'];
    transferAllowance = json['transfer_allowance'];
    mealAllowance = json['meal_allowance'];
    guestHouseAccommodation = json['guest_house_accommodation'];
    advancePayment = json['advance_payment']?? 0;
    if (json['traveller'] != null) {
      traveller = new List<Traveller>();
      json['traveller'].forEach((v) {
        traveller.add(new Traveller.fromJson(v));
      });
    }
    if (json['travelDestinations'] != null) {
      travelDestinations = new List<TravelDestinations>();
      json['travelDestinations'].forEach((v) {
        travelDestinations.add(new TravelDestinations.fromJson(v));
      });
    }
    if (json['travelPlanAuthorities'] != null) {
      travelPlanAuthorities = new List<TravelPlanAuthorities>();
      json['travelPlanAuthorities'].forEach((v) {
        travelPlanAuthorities.add(new TravelPlanAuthorities.fromJson(v));
      });
    }
    travelPlanStatus = json['travel_plan_status'];
    inProgressAuthority = json['in_progress_authority'];
    travelSettlement = json['travelSettlement'] != null
        ? new SRDTravelSettlement.fromJson(json['travelSettlement'])
        : null;

    if (json['travelSettlementAuthority'] != null) {
      travelSettlementAuthority = <TravelSettlementAuthority>[];
      json['travelSettlementAuthority'].forEach((v) {
        travelSettlementAuthority
            .add(new TravelSettlementAuthority.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
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
    if (this.travelDestinations != null) {
      data['travelDestinations'] =
          this.travelDestinations.map((v) => v.toJson()).toList();
    }
    if (this.travelPlanAuthorities != null) {
      data['travelPlanAuthorities'] =
          this.travelPlanAuthorities.map((v) => v.toJson()).toList();
    }
    data['travel_plan_status'] = this.travelPlanStatus;
    data['in_progress_authority'] = this.inProgressAuthority;
    if (this.travelSettlement != null) {
      data['travelSettlement'] = this.travelSettlement.toJson();
    }
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
    code = json['code'];
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

class TravelDestinations {
  String travelStart;
  String travelEnd;

  TravelDestinations({this.travelStart, this.travelEnd});

  TravelDestinations.fromJson(Map<String, dynamic> json) {
    travelStart = json['travel_start']??'';
    travelEnd = json['travel_end']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['travel_start'] = this.travelStart;
    data['travel_end'] = this.travelEnd;
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
    authorityName = json['authority_name']??'';
    authorityOrder = json['authority_order'];
    authorityStatus = json['authority_status']??'';
    processedEmployee = json['processed_employee']??'';
    createdAt = json['created_at']??'';
    remarks = json['remarks']??'';
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

class SRDTravelSettlement {
  int id;
  int travelPlanId;
  int employeeId;
  int airTicketAmount;
  String airTicketAttachment;
  int hotelAccomodationAmount;
  String hotelAccomodationAttachment;
  int guestHouseAccommodationAmount;
  String guestHouseAccommodationAttachment;
  int transportAmount;
  String transportAttachment;
  int dailyAllowanceAmount;
  String dailyAllowanceAttachment;
  int mealAllowanceAmount;
  String mealAllowanceAttachment;
  int transferAllowanceAmount;
  String transferAllowanceAttachment;
  String attachment;
  String comments;
  String status;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;
  // List<TravelSettlementAuthority> travelSettlementAuthority;

  SRDTravelSettlement(
      {this.id,
        this.travelPlanId,
        this.employeeId,
        this.airTicketAmount,
        this.airTicketAttachment,
        this.hotelAccomodationAmount,
        this.hotelAccomodationAttachment,
        this.guestHouseAccommodationAmount,
        this.guestHouseAccommodationAttachment,
        this.transportAmount,
        this.transportAttachment,
        this.dailyAllowanceAmount,
        this.dailyAllowanceAttachment,
        this.mealAllowanceAmount,
        this.mealAllowanceAttachment,
        this.transferAllowanceAmount,
        this.transferAllowanceAttachment,
        this.attachment,
        this.comments,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        //this.travelSettlementAuthority
      });

  SRDTravelSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelPlanId = json['travel_plan_id'];
    employeeId = json['employee_id'];
    airTicketAmount = json['air_ticket_amount'] ?? 0;
    airTicketAttachment = json['air_ticket_attachment'];
    hotelAccomodationAmount = json['hotel_accomodation_amount'] ?? 0;
    hotelAccomodationAttachment = json['hotel_accomodation_attachment'];
    guestHouseAccommodationAmount = json['guest_house_accommodation_amount'] ?? 0;
    guestHouseAccommodationAttachment = json['guest_house_accommodation_attachment'];
    transportAmount = json['transport_amount'] ?? 0;
    transportAttachment = json['transport_attachment'];
    dailyAllowanceAmount = json['daily_allowance_amount'] ?? 0;
    dailyAllowanceAttachment = json['daily_allowance_attachment'];
    mealAllowanceAmount = json['meal_allowance_amount'] ?? 0;
    mealAllowanceAttachment = json['meal_allowance_attachment'];
    transferAllowanceAmount = json['transfer_allowance_amount'] ?? 0;
    transferAllowanceAttachment = json['transfer_allowance_attachment'];
    attachment = json['attachment'];
    comments = json['comments']??'';;
    status = json['status']??'';;
    // createdBy = json['created_by'];
    // updatedBy = json['updated_by'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // if (json['travel_settlement_authority'] != null) {
    //   travelSettlementAuthority = new List<TravelSettlementAuthority>();
    //   json['travel_settlement_authority'].forEach((v) {
    //     travelSettlementAuthority
    //         .add(new TravelSettlementAuthority.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['travel_plan_id'] = this.travelPlanId;
    data['employee_id'] = this.employeeId;
    data['air_ticket_amount'] = this.airTicketAmount;
    data['air_ticket_attachment'] = this.airTicketAttachment;
    data['hotel_accomodation_amount'] = this.hotelAccomodationAmount;
    data['hotel_accomodation_attachment'] = this.hotelAccomodationAttachment;
    data['guest_house_accommodation_amount'] =
        this.guestHouseAccommodationAmount;
    data['guest_house_accommodation_attachment'] =
        this.guestHouseAccommodationAttachment;
    data['transport_amount'] = this.transportAmount;
    data['transport_attachment'] = this.transportAttachment;
    data['daily_allowance_amount'] = this.dailyAllowanceAmount;
    data['daily_allowance_attachment'] = this.dailyAllowanceAttachment;
    data['meal_allowance_amount'] = this.mealAllowanceAmount;
    data['meal_allowance_attachment'] = this.mealAllowanceAttachment;
    data['transfer_allowance_amount'] = this.transferAllowanceAmount;
    data['transfer_allowance_attachment'] = this.transferAllowanceAttachment;
    data['attachment'] = this.attachment;
    data['comments'] = this.comments;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    // if (this.travelSettlementAuthority != null) {
    //   data['travel_settlement_authority'] =
    //       this.travelSettlementAuthority.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class TravelSettlementAuthority {
  String authorityName;
  String status;
  //Null statusDate;
  String remarks;
  //Null processedBy;

  TravelSettlementAuthority(
      {this.authorityName,
        this.status,
        //this.statusDate,
        this.remarks,
        //this.processedBy
  });

  TravelSettlementAuthority.fromJson(Map<String, dynamic> json) {
    authorityName = json['authority_name'];
    status = json['status'];
    //statusDate = json['status_date'];
    remarks = json['remarks']?? '';
    //processedBy = json['processed_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authority_name'] = this.authorityName;
    data['status'] = this.status;
    //data['status_date'] = this.statusDate;
    data['remarks'] = this.remarks;
    //data['processed_by'] = this.processedBy;
    return data;
  }
}