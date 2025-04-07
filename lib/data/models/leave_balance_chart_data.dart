class LeaveBalanceChartData {
  //List<LeaveBalanceChartItem> leaveBalanceList;
  var leaveBalanceList = <LeaveBalanceChartItem>[];

  LeaveBalanceChartData({this.leaveBalanceList});

  LeaveBalanceChartData.fromJson(Map<String, dynamic> json) {

    if (json['leaveBalance'] != null) {
      //print(json['leaveBalance'].toString());
      leaveBalanceList = <LeaveBalanceChartItem>[]; //new List<LeaveBalanceChartItem>();

      json['leaveBalance'].forEach((v) {
        var item =new LeaveBalanceChartItem.fromJson(v);

        //--------------Rakib--------------------
        //Checking Allocated leave > 0; Because "section's value can't be zero in Pie Chart",
        if( item.total > 0){leaveBalanceList.add(item);}
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaveBalanceList != null) {
      data['leaveBalance'] =
          this.leaveBalanceList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveBalanceChartItem {
  String leaveName;
  double total;
  double availed;
  double forwarded;
  double balance;
  double encashed;

  LeaveBalanceChartItem(
      { this.leaveName, this.total, this.availed,this.forwarded, this.balance,this.encashed});

  LeaveBalanceChartItem.fromJson(Map<String, dynamic> json) {
    //print('-------------------Rakib------------');

    leaveName = json['leave_type'];
    total = double.parse(json['allocated_leave'].toString());
    availed = double.parse(json['leave_consumed'].toString());
    forwarded = double.parse(json['forwarded_leave'].toString());
    balance = double.parse(json['remaining'].toString());
    encashed = double.parse(json['encashed_leave'].toString());



    // id = json['Id'].toInt();
    // leaveName = json['LeaveName'];
    // total = json['Total'];
    // availed = json['Availed'];
    // balance = json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //print('-------------------Rakib------------');
    data['leave_type'] = this.leaveName;
    data['allocated_leave'] = this.total;
    data['leave_consumed'] = this.availed;
    data['forwarded_leave'] = this.forwarded;
    data['remaining'] = this.balance;

    // data['Id'] = this.id;
    // data['LeaveName'] = this.leaveName;
    // data['Total'] = this.total;
    // data['Availed'] = this.availed;
    // data['Balance'] = this.balance;
    return data;
  }
}
