class EditSettlement {
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
  Stream mealAllowanceAttachment;
  int transferAllowanceAmount;
  String transferAllowanceAttachment;
  String attachment;
  String comments;
  String status;

  EditSettlement(
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
        this.status});

  EditSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    travelPlanId = json['travel_plan_id'];
    employeeId = json['employee_id'];
    airTicketAmount = json['air_ticket_amount']??0;
    airTicketAttachment = json['air_ticket_attachment'];
    hotelAccomodationAmount = json['hotel_accomodation_amount']??0;
    hotelAccomodationAttachment = json['hotel_accomodation_attachment'];
    guestHouseAccommodationAmount = json['guest_house_accommodation_amount']??0;
    guestHouseAccommodationAttachment = json['guest_house_accommodation_attachment'];
    transportAmount = json['transport_amount']??0;
    transportAttachment = json['transport_attachment'];
    dailyAllowanceAmount = json['daily_allowance_amount']??0;
    dailyAllowanceAttachment = json['daily_allowance_attachment'];
    mealAllowanceAmount = json['meal_allowance_amount']??0;
    mealAllowanceAttachment = json['meal_allowance_attachment'];
    transferAllowanceAmount = json['transfer_allowance_amount']??0;
    transferAllowanceAttachment = json['transfer_allowance_attachment'];
    attachment = json['attachment'];
    comments = json['comments'] ?? '';
    status = json['status'];
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
    return data;
  }
}