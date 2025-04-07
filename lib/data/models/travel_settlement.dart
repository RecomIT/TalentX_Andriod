class TravelSettlement {
  int id;
  int airTicket;
  int hotelAccommodation;
  int transport;
  int dailyAllowance;
  int mealAllowance;
  int transferAllowance;
  int guestHouseAccommodation;

  TravelSettlement(
      {this.id,
        this.airTicket,
        this.hotelAccommodation,
        this.transport,
        this.dailyAllowance,
        this.mealAllowance,
        this.transferAllowance,this.guestHouseAccommodation});

  TravelSettlement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    airTicket = json['air_ticket'] ?? 0;
    hotelAccommodation = json['hotel_accommodation'] ?? 0;
    transport = json['transport'] ?? 0;
    dailyAllowance = json['daily_allowance'] ?? 0;
    mealAllowance = json['meal_allowance'] ?? 0;
    transferAllowance = json['transfer_allowance'] ?? 0;
    guestHouseAccommodation = json['guest_house_accommodation'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['air_ticket'] = this.airTicket;
    data['hotel_accommodation'] = this.hotelAccommodation;
    data['transport'] = this.transport;
    data['daily_allowance'] = this.dailyAllowance;
    data['meal_allowance'] = this.mealAllowance;
    data['transfer_allowance'] = this.transferAllowance;
    return data;
  }
}