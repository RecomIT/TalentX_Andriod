class IfterSubscriptionDetailsList {
  var ifterSubscriptionDetailList = <IfterSubscriptionDetails>[];

  IfterSubscriptionDetailsList({this.ifterSubscriptionDetailList});

  IfterSubscriptionDetailsList.fromJson(Map<String, dynamic> json) {
    if (json['ifterSubscriptionDetailList'] != null) {
      ifterSubscriptionDetailList = <IfterSubscriptionDetails>[];
      json['ifterSubscriptionDetailList'].forEach((v) {
        ifterSubscriptionDetailList.add(IfterSubscriptionDetails.fromJson(v));
      });
    }
  }
}

class IfterSubscriptionDetails {
  int id;
  int lunchSubscriptionId;
  int totalLunchBill;
  int totalLunchTaken;
  String month;
  String subscriptionDate;
  String unSubscriptionDate;

  IfterSubscriptionDetails(
      {this.id,
        this.lunchSubscriptionId,
        this.totalLunchBill,
        this.totalLunchTaken,
        this.month,
        this.subscriptionDate,
        this.unSubscriptionDate});

  IfterSubscriptionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    lunchSubscriptionId = json['lunch_subscription_id']??0;
    totalLunchBill = json['total_lunch_bill']??0;
    totalLunchTaken = json['total_lunch_taken']??0;
    month = json['month']?? 'N/A';
    subscriptionDate = json['subscription_date']??'N/A';
    unSubscriptionDate = json['un_subscription_date']??'N/A';
  }

}