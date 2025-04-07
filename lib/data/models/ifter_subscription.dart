class IfterSubscriptionList {
  var ifterSubscriptionList = <IfterSubscription>[];

  IfterSubscriptionList({this.ifterSubscriptionList});

  IfterSubscriptionList.fromJson(Map<String, dynamic> json) {
    if (json['ifterSubscriptionList'] != null) {
      ifterSubscriptionList = <IfterSubscription>[];
      json['ifterSubscriptionList'].forEach((v) {
        ifterSubscriptionList.add(IfterSubscription.fromJson(v));
      });
    }
  }
}


class IfterSubscription {
  int id;
  String requestRaiseDate;
  String availingDate;
  int quantity;


  String subscriptionDate;
  String rfid;
  String food;
  String fromDate;
  String toDate;
  int deductionAmount;
  String lunchPolicy;
  int subsidyAmount;
  String status;

  IfterSubscription(
      {this.id,
        this.requestRaiseDate,
        this.availingDate,
        this.quantity,
        this.subscriptionDate,
        this.rfid,
        this.food,
        this.fromDate,
        this.toDate,
        this.deductionAmount,
        this.subsidyAmount,
        this.status,this.lunchPolicy});

  IfterSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    requestRaiseDate = json['request_raise_date']??'N/A';
    availingDate = json['availing_date']??'N/A';
    quantity = json['quantity']??0;

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