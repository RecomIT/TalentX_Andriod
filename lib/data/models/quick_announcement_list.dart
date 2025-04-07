class QuickAnnouncementList {
  List<QuickAnnouncement> quickAnnouncementList;

  QuickAnnouncementList({this.quickAnnouncementList});

  QuickAnnouncementList.fromJson(Map<String, dynamic> json) {
    if (json['quickAnnouncement'] != null) {
      quickAnnouncementList = new List<QuickAnnouncement>();
      json['quickAnnouncement'].forEach((v) {
        quickAnnouncementList.add(new QuickAnnouncement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.quickAnnouncementList != null) {
      data['quickAnnouncement'] = this.quickAnnouncementList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuickAnnouncement {
  int id;
  String title;
  String startDate;
  String endDate;
  String purpose;

  QuickAnnouncement({this.id, this.title, this.startDate, this.endDate, this.purpose});

  QuickAnnouncement.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    purpose = json['Purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Purpose'] = this.purpose;
    return data;
  }
}
