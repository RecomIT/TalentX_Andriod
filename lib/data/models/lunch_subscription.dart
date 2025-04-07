class LunchSubscriptionList {
  var lunchSubscriptionList = <LunchSubscription>[];

  LunchSubscriptionList({this.lunchSubscriptionList});

  LunchSubscriptionList.fromJson(Map<String, dynamic> json) {
    if (json['lunchSubscriptionList'] != null) {
      lunchSubscriptionList = <LunchSubscription>[];
      json['lunchSubscriptionList'].forEach((v) {
        lunchSubscriptionList.add(LunchSubscription.fromJson(v));
      });
    }
  }
}


class LunchSubscription {
  int id;
  String subscriptionDate;
  String rfid;
  String food;
  String fromDate;
  String toDate;
  int deductionAmount;
  String lunchPolicy;
  int subsidyAmount;
  String status;

  LunchSubscription(
      {this.id,
        this.subscriptionDate,
        this.rfid,
        this.food,
        this.fromDate,
        this.toDate,
        this.deductionAmount,
        this.subsidyAmount,
        this.status,this.lunchPolicy});

  LunchSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    subscriptionDate = json['subscription_date']??'N/A';
    rfid = json['rfid']??'N/A';
    food = json['food']??'N/A';
    fromDate = json['from_date']??'N/A';
    toDate = json['to_date']??'N/A';
    deductionAmount = json['deduction_amount']??0;
    lunchPolicy = json['lunch_policy']??'N/A';
    subsidyAmount = json['subsidy_amount']??0;
    status = json['status']??'N/A';
  }

}