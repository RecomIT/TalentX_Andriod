class MySettlementList {
  List<MySettlement> mySettlements;

  MySettlementList({this.mySettlements});

  MySettlementList.fromJson(Map<String, dynamic> json) {
    if (json['mySettlements'] != null && json['mySettlements'] is List) {
      mySettlements = <MySettlement>[];
      json['mySettlements'].forEach((v) {
        mySettlements.add(MySettlement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.mySettlements != null) {
      data['mySettlements'] = this.mySettlements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}



class MySettlement {
  int travelSettlementId;
  String referenceNo;
  String travelType;
  String purpose;
  String tripType;
  String transportMode;
  String year;
  String moth;
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

  MySettlement(
      {this.travelSettlementId,
        this.referenceNo,
        this.travelType,
        this.purpose,
        this.tripType,
        this.transportMode,
        this.year,
        this.moth,
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
        this.status});

  MySettlement.fromJson(Map<String, dynamic> json) {
    travelSettlementId = json['travel_settlement_id'];
    referenceNo = json['reference_no'];
    travelType = json['travel_type'];
    purpose = json['purpose'];
    tripType = json['trip_type'];
    transportMode = json['transport_mode'];
    year = json['year'];
    moth = json['moth'];
    airTicketAmount = json['air_ticket_amount'] ?? 0;
    airTicketAttachment = json['air_ticket_attachment'];
    hotelAccomodationAmount = json['hotel_accomodation_amount'] ?? 0;
    hotelAccomodationAttachment = json['hotel_accomodation_attachment'];
    guestHouseAccommodationAmount = json['guest_house_accommodation_amount'] ?? 0;
    guestHouseAccommodationAttachment =
    json['guest_house_accommodation_attachment'];
    transportAmount = json['transport_amount'] ?? 0;
    transportAttachment = json['transport_attachment'];
    dailyAllowanceAmount = json['daily_allowance_amount'] ?? 0;
    dailyAllowanceAttachment = json['daily_allowance_attachment'];
    mealAllowanceAmount = json['meal_allowance_amount'] ?? 0;
    mealAllowanceAttachment = json['meal_allowance_attachment'];
    transferAllowanceAmount = json['transfer_allowance_amount'] ?? 0;
    transferAllowanceAttachment = json['transfer_allowance_attachment'];
    attachment = json['attachment'];
    comments = json['comments'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['travel_settlement_id'] = this.travelSettlementId;
    data['reference_no'] = this.referenceNo;
    data['travel_type'] = this.travelType;
    data['purpose'] = this.purpose;
    data['trip_type'] = this.tripType;
    data['transport_mode'] = this.transportMode;
    data['year'] = this.year;
    data['moth'] = this.moth;
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
    return data;
  }
}