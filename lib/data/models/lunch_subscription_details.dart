class LunchSubscriptionDetailsList {
  var lunchSubscriptionDetailList = <LunchSubscriptionDetails>[];

  LunchSubscriptionDetailsList({this.lunchSubscriptionDetailList});

  LunchSubscriptionDetailsList.fromJson(Map<String, dynamic> json) {
    if (json['lunchSubscriptionDetailList'] != null) {
      lunchSubscriptionDetailList = <LunchSubscriptionDetails>[];
      json['lunchSubscriptionDetailList'].forEach((v) {
        lunchSubscriptionDetailList.add(LunchSubscriptionDetails.fromJson(v));
      });
    }
  }
}

class LunchSubscriptionDetails {
  int id;
  int lunchSubscriptionId;
  int totalLunchBill;
  int totalLunchTaken;
  String month;
  String subscriptionDate;
  String unSubscriptionDate;

  LunchSubscriptionDetails(
      {this.id,
        this.lunchSubscriptionId,
        this.totalLunchBill,
        this.totalLunchTaken,
        this.month,
        this.subscriptionDate,
        this.unSubscriptionDate});

  LunchSubscriptionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    lunchSubscriptionId = json['lunch_subscription_id']??0;
    totalLunchBill = json['total_lunch_bill']??0;
    totalLunchTaken = json['total_lunch_taken']??0;
    month = json['month']?? 'N/A';
    subscriptionDate = json['subscription_date']??'N/A';
    unSubscriptionDate = json['un_subscription_date']??'N/A';
  }

}