class EditTavelPlan {
  int id;
  int employeeId;
  String referenceNo;
  String transportMode;
  String workPlace;
  String startDate;
  String endDate;
  String travelType;
  String purpose;
  String tripType;
  int exHeadQuater;
  int outstation;
  String description;
  String document;
  int hotelAccommodation; //bool type
  int hotelAccommodationByAdminDpt;
  int hotelAccommodationAmount;
  int transport;//bool type
  int transportByAdminDpt;
  int transportAmount;
  int dailyAllowance;//bool type
  int dailyAllowanceAmount;
  int transferAllowance;//bool type
  int mealAllowance;//bool type
  int mealAllowanceAmount;
  int airTicket;//bool type
  int airTicketByAdminDpt;
  int guestHouseAccommodation;//bool type
  int advancePayment;//bool type
  List<String> traveller;
  List<String> costCenter;
  String hrGroup;
  List<int> hrGroupEmployee;
  String currency;
  String status;
  int settlement;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;
  Employee employee;
  List<TravelPlanAuthorities> travelPlanAuthorities;
  List<TravelRoutes> travelRoutes;
  EditTravelSettlement travelSettlement;

  String paymentMethod;
  String accountName;
  String accountNumber;
  String bankName;
  String bankAccountName;
  String bankAccountNumber;
  String branchName;
  String routingNo;

  EditTavelPlan(
      {this.id,
        this.employeeId,
        this.referenceNo,
        this.transportMode,
        this.workPlace,
        this.startDate,
        this.endDate,
        this.travelType,
        this.purpose,
        this.tripType,
        this.exHeadQuater,
        this.outstation,
        this.description,
        this.document,
        this.hotelAccommodation,
        this.hotelAccommodationAmount,
        this.hotelAccommodationByAdminDpt,
        this.transport,
        this.transportAmount,
        this.transportByAdminDpt,
        this.dailyAllowance,
        this.dailyAllowanceAmount,
        this.transferAllowance,
        this.mealAllowance,
        this.mealAllowanceAmount,
        this.airTicket,
        this.airTicketByAdminDpt,
        this.guestHouseAccommodation,
        this.advancePayment,
        this.traveller,
        this.costCenter,
        this.hrGroup,
        this.hrGroupEmployee,
        this.currency,
        this.status,
        this.settlement,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.employee,
        this.travelPlanAuthorities,
        this.travelRoutes,
        this.travelSettlement,
        this.paymentMethod,
        this.accountName,
        this.accountNumber,
        this.bankName,
        this.bankAccountName,
        this.bankAccountNumber,
        this.branchName,
        this.routingNo});

  EditTavelPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    referenceNo = json['reference_no'];
    transportMode = json['transport_mode'];
    workPlace = json['work_place'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    travelType = json['travel_type'];
    purpose = json['purpose'];
    tripType = json['trip_type'];
    // exHeadQuater = json['ex_head_quater'];
    // outstation = json['outstation'];
    description = json['description'];
    document = json['document'];
    hotelAccommodation = json['hotel_accommodation'] ?? 0;
    hotelAccommodationByAdminDpt = json['hotel_accommodation_by_admin_dept'] ?? 0;
    hotelAccommodationAmount =json['hotel_accommodation_amount']??0;
    transport = json['transport']?? 0;
    transportByAdminDpt = json['transport_by_admin_dept'] ?? 0;
    transportAmount =json['transport_amount']??0;
    dailyAllowance = json['daily_allowance']?? 0;
    dailyAllowanceAmount = json['daily_allowance_amount']??0;
    transferAllowance = json['transfer_allowance']?? 0;
    mealAllowance = json['meal_allowance']?? 0;
    mealAllowanceAmount = json['meal_allowance_amount']?? 0;

    airTicket = json['air_ticket']?? 0;
    airTicketByAdminDpt = json['air_ticket_by_admin_dept'] ?? 0;
    guestHouseAccommodation = json['guest_house_accommodation']?? 0;
    advancePayment = json['advance_payment']?? 0;
    traveller =  json['traveller'] == null ? [] : json['traveller'].cast<String>();
    costCenter =  json['cost_center'] == null ? [] : json['cost_center'].cast<String>();
    hrGroup = json['hr_group'];
    hrGroupEmployee = json['hr_group_employee'] == null ? [] : json['hr_group_employee'].cast<int>();
    currency = json['currency'];
    status = json['status'];
    settlement = json['settlement'];
    // createdBy = json['created_by'];
    // updatedBy = json['updated_by'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    if (json['travel_plan_authorities'] != null) {
      travelPlanAuthorities =  <TravelPlanAuthorities>[];
      json['travel_plan_authorities'].forEach((v) {
        travelPlanAuthorities.add(new TravelPlanAuthorities.fromJson(v));
      });
    }
    if (json['travel_routes_reverted'] != null) {
      travelRoutes = <TravelRoutes>[];
      json['travel_routes_reverted'].forEach((v) {
        travelRoutes.add(new TravelRoutes.fromJson(v));
      });
    }
    travelSettlement = json['travel_settlement'] != null
        ? new EditTravelSettlement.fromJson(json['travel_settlement'])
        : null;
    paymentMethod = json['payment_method']??'N/A';
    accountName= json['account_name']??'N/A';
    accountNumber= json['account_number']??'N/A';
    bankName = json['bank_name']??'N/A';
    bankAccountName = json['bank_account_name']??'N/A';
    bankAccountNumber = json['bank_account_number']??'N/A';
    branchName = json['branch_name']??'N/A';
    routingNo = json['routing_no']??'N/A';
  }
}

class Employee {
  int id;
  int userId;
  int noticePeriod;
  int temporaryPeriod;
  int departmentId;
  int designationId;
  int divisionId;
  int gradeId;
  int employeeRoleId;
  int areaId;
  int projectId;
  String simBundleCode;
  int bankId;
  int branchId;
  int supervisorId;
  int teamId;
  int employeetypeId;
  int locationId;
  int fundNameId;
  int unitId;
  int categoryId;
  int salaryDisburseId;
  String code;
  String firstName;
  String middleName;
  String lastName;
  String joiningDate;
  String confirmationDate;
  String phone;
  String email;
  String profilePhoto;
  String presentAddress;
  String permanentAddress;
  String religion;
  String gender;
  String dob;
  String nationality;
  String maritalStatus;
  String fatherName;
  String motherName;
  String spouse;
  String spouseMobile;
  String tinNumber;
  String nationalId;
  String drivingLicenseNumber;
  String birthCertificateNumber;
  String passportNo;
  String passportValidityTill;
  String accountType;
  String accountNumber;
  Payment payment;
  String confirmedBy;
  String confirmedAt;
  String pf;
  String pfStartDate;
  int expatriate;
  int status;
  String remark;
  String altEmail;
  String altPhone;
  String emergencyContactName;
  String emergencyContactRelation;
  String emergencyContactPhone;
  int emergencyContactNid;
  String emergencyContactAddress;
  String education;
  String bloodGroup;
  int costCenterId;
  int businessUnitId;
  String costType;
  int salaryHold;
  String salaryHoldReason;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;
  String resignedDate;
  Department department;
  CostCenter costCenter;
  Division division;

  Employee(
      {this.id,
        this.userId,
        this.noticePeriod,
        this.temporaryPeriod,
        this.departmentId,
        this.designationId,
        this.divisionId,
        this.gradeId,
        this.employeeRoleId,
        this.areaId,
        this.projectId,
        this.simBundleCode,
        this.bankId,
        this.branchId,
        this.supervisorId,
        this.teamId,
        this.employeetypeId,
        this.locationId,
        this.fundNameId,
        this.unitId,
        this.categoryId,
        this.salaryDisburseId,
        this.code,
        this.firstName,
        this.middleName,
        this.lastName,
        this.joiningDate,
        this.confirmationDate,
        this.phone,
        this.email,
        this.profilePhoto,
        this.presentAddress,
        this.permanentAddress,
        this.religion,
        this.gender,
        this.dob,
        this.nationality,
        this.maritalStatus,
        this.fatherName,
        this.motherName,
        this.spouse,
        this.spouseMobile,
        this.tinNumber,
        this.nationalId,
        this.drivingLicenseNumber,
        this.birthCertificateNumber,
        this.passportNo,
        this.passportValidityTill,
        this.accountType,
        this.accountNumber,
        this.payment,
        this.confirmedBy,
        this.confirmedAt,
        this.pf,
        this.pfStartDate,
        this.expatriate,
        this.status,
        this.remark,
        this.altEmail,
        this.altPhone,
        this.emergencyContactName,
        this.emergencyContactRelation,
        this.emergencyContactPhone,
        this.emergencyContactNid,
        this.emergencyContactAddress,
        this.education,
        this.bloodGroup,
        this.costCenterId,
        this.businessUnitId,
        this.costType,
        this.salaryHold,
        this.salaryHoldReason,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.resignedDate,
        this.department,
        this.costCenter,
        this.division});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    // noticePeriod = json['notice_period'];
    // temporaryPeriod = json['temporary_period'];
    // departmentId = json['department_id'];
    // designationId = json['designation_id'];
    // divisionId = json['division_id'];
    // gradeId = json['grade_id'];
    // employeeRoleId = json['employee_role_id'];
    // areaId = json['area_id'];
    // projectId = json['project_id'];
    // simBundleCode = json['sim_bundle_code'];
    // bankId = json['bank_id'];
    // branchId = json['branch_id'];
    supervisorId = json['supervisor_id'];
    //teamId = json['team_id'];
    // employeetypeId = json['employeetype_id'];
    // locationId = json['location_id'];
    // fundNameId = json['fund_name_id'];
    // unitId = json['unit_id'];
    // categoryId = json['category_id'];
    // salaryDisburseId = json['salary_disburse_id'];
    // code = json['code'];
    firstName = json['first_name']??'';
    middleName = json['middle_name']??'';
    lastName = json['last_name']??'';
    // joiningDate = json['joining_date'];
    // confirmationDate = json['confirmation_date'];
    // phone = json['phone'];
    // email = json['email'];
    // profilePhoto = json['profile_photo'];
    // presentAddress = json['present_address'];
    // permanentAddress = json['permanent_address'];
    // religion = json['religion'];
    // gender = json['gender'];
    // dob = json['dob'];
    // nationality = json['nationality'];
    // maritalStatus = json['marital_status'];
    // fatherName = json['father_name'];
    // motherName = json['mother_name'];
    // spouse = json['spouse'];
    // spouseMobile = json['spouse_mobile'];
    // tinNumber = json['tin_number'];
    // nationalId = json['national_id'];
    // drivingLicenseNumber = json['driving_license_number'];
    // birthCertificateNumber = json['birth_certificate_number'];
    // passportNo = json['passport_no'];
    // passportValidityTill = json['passport_validity_till'];
    // accountType = json['account_type'];
    // accountNumber = json['account_number'];
    // payment =
    // json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    // confirmedBy = json['confirmed_by'];
    // confirmedAt = json['confirmed_at'];
    // pf = json['pf'];
    // pfStartDate = json['pf_start_date'];
    // expatriate = json['expatriate'];
    // status = json['status'];
    // remark = json['remark'];
    // altEmail = json['alt_email'];
    // altPhone = json['alt_phone'];
    // emergencyContactName = json['emergency_contact_name'];
    // emergencyContactRelation = json['emergency_contact_relation'];
    // emergencyContactPhone = json['emergency_contact_phone'];
    // emergencyContactNid = json['emergency_contact_nid'];
    // emergencyContactAddress = json['emergency_contact_address'];
    // education = json['education'];
    // bloodGroup = json['blood_group'];
    // costCenterId = json['cost_center_id'];
    // businessUnitId = json['business_unit_id'];
    // costType = json['cost_type'];
    // salaryHold = json['salary_hold'];
    // salaryHoldReason = json['salary_hold_reason'];
    // createdBy = json['created_by'];
    // updatedBy = json['updated_by'];
    // deletedAt = json['deleted_at'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // resignedDate = json['resigned_date'];
    // department = json['department'] != null
    //     ? new Department.fromJson(json['department'])
    //     : null;
    // costCenter = json['cost_center'] != null
    //     ? new CostCenter.fromJson(json['cost_center'])
    //     : null;
    // division = json['division'] != null
    //     ? new Division.fromJson(json['division'])
    //     : null;
  }
}

class Payment {
  String bankId;
  String accountName;
  String paymentType;
  String bankAccountNumber;

  Payment(
      {this.bankId,
        this.accountName,
        this.paymentType,
        this.bankAccountNumber});

  Payment.fromJson(Map<String, dynamic> json) {
    bankId = json['bank_id'];
    accountName = json['account_name'];
    paymentType = json['payment_type'];
    bankAccountNumber = json['bank_account_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_id'] = this.bankId;
    data['account_name'] = this.accountName;
    data['payment_type'] = this.paymentType;
    data['bank_account_number'] = this.bankAccountNumber;
    return data;
  }
}

class Department {
  int id;
  String shortCode;
  String name;
  String detail;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  Department(
      {this.id,
        this.shortCode,
        this.name,
        this.detail,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortCode = json['short_code'];
    name = json['name'];
    detail = json['detail'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['short_code'] = this.shortCode;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CostCenter {
  int id;
  String name;
  String costCenterCode;
  String description;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  CostCenter(
      {this.id,
        this.name,
        this.costCenterCode,
        this.description,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  CostCenter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    costCenterCode = json['cost_center_code'];
    description = json['description'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cost_center_code'] = this.costCenterCode;
    data['description'] = this.description;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Division {
  int id;
  String name;
  String detail;
  int createdBy;
  int updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  Division(
      {this.id,
        this.name,
        this.detail,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    detail = json['detail'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TravelPlanAuthorities {
  int id;
  int travelPlanId;
  int employeeId;
  int altEmployeeId;
  int authorityOrder;
  String remarks;
  String status;
  String statusDate;
  int processedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  TravelPlanAuthorities(
      {this.id,
        this.travelPlanId,
        this.employeeId,
        this.altEmployeeId,
        this.authorityOrder,
        this.remarks,
        this.status,
        this.statusDate,
        this.processedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  TravelPlanAuthorities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelPlanId = json['travel_plan_id'];
    employeeId = json['employee_id'];
    altEmployeeId = json['alt_employee_id'];
    authorityOrder = json['authority_order'];
    remarks = json['remarks'];
    status = json['status'];
    statusDate = json['status_date'];
    processedBy = json['processed_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class TravelRoutes {
  int id;
  int travelPlanId;
  int fromTravelDestinationId;
  int toTravelDestinationId;
  String startDate;
  String endDate;
  String note;
  int createdBy;
  String updatedBy;
  String deletedAt;
  String createdAt;
  String updatedAt;

  TravelRoutes(
      {this.id,
        this.travelPlanId,
        this.fromTravelDestinationId,
        this.toTravelDestinationId,
        this.startDate,
        this.endDate,
        this.note,
        this.createdBy,
        this.updatedBy,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  TravelRoutes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelPlanId = json['travel_plan_id'];
    fromTravelDestinationId = json['from_travel_destination_id'];
    toTravelDestinationId = json['to_travel_destination_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    note = json['note'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class EditTravelSettlement {
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

  EditTravelSettlement(
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
        this.updatedAt});

  EditTravelSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelPlanId = json['travel_plan_id'];
    employeeId = json['employee_id'];
    airTicketAmount = json['air_ticket_amount'];
    airTicketAttachment = json['air_ticket_attachment'];
    hotelAccomodationAmount = json['hotel_accomodation_amount'];
    hotelAccomodationAttachment = json['hotel_accomodation_attachment'];
    guestHouseAccommodationAmount = json['guest_house_accommodation_amount'];
    guestHouseAccommodationAttachment = json['guest_house_accommodation_attachment'];
    transportAmount = json['transport_amount'];
    transportAttachment = json['transport_attachment'];
    dailyAllowanceAmount = json['daily_allowance_amount'];
    dailyAllowanceAttachment = json['daily_allowance_attachment'];
    mealAllowanceAmount = json['meal_allowance_amount'];
    mealAllowanceAttachment = json['meal_allowance_attachment'];
    transferAllowanceAmount = json['transfer_allowance_amount'];
    transferAllowanceAttachment = json['transfer_allowance_attachment'];
    attachment = json['attachment'];
    comments = json['comments'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}