class SchedulerRequestData {
  List<SchedulerRequest> schedulerRequest;

  SchedulerRequestData({this.schedulerRequest});

  SchedulerRequestData.fromJson(Map<String, dynamic> json) {
    if (json['schedulerRequest'] != null) {
      schedulerRequest = new List<SchedulerRequest>();
      json['schedulerRequest'].forEach((v) {
        schedulerRequest.add(new SchedulerRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedulerRequest != null) {
      data['schedulerRequest'] = this.schedulerRequest.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchedulerRequest {
  Scheduler scheduler;

  SchedulerRequest({this.scheduler});

  SchedulerRequest.fromJson(Map<String, dynamic> json) {
    scheduler = json['Scheduler'] != null ? new Scheduler.fromJson(json['Scheduler']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.scheduler != null) {
      data['Scheduler'] = this.scheduler.toJson();
    }

    return data;
  }
}

class Scheduler {
  int sID;
  String subject;
  String details;
  String location;
  String date;
  String time;
  List<String> guestIds;

  Scheduler({this.sID, this.subject, this.details, this.location, this.date, this.time, this.guestIds});

  Scheduler.fromJson(Map<String, dynamic> json) {
    sID = json['SID'];
    subject = json['Subject'];
    details = json['Details'];
    location = json['Location'];
    date = json['Date'];
    time = json['Time'];
    if (json['GuestIds'] != null) {
      guestIds = new List<String>();
      json['GuestIds'].forEach((v) {
        guestIds.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SID'] = this.sID;
    data['Subject'] = this.subject;
    data['Details'] = this.details;
    data['Location'] = this.location;
    data['Date'] = this.date;
    data['Time'] = this.time;
    if (this.guestIds != null) {
      data['GuestIds'] = this.guestIds.map((v) => v).toList();
    }
    return data;
  }
}
