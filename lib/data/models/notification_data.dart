class NotificationData {
  List<NotificationInfo> notification;

  NotificationData({this.notification});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification =  <NotificationInfo>[];
      json['notification'].forEach((v) {
        notification.add(new NotificationInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationInfo {
  String id;
  String type;
  String notifiableType;
  int notifiableId;
  Data data;
  String readAt;
  String createdAt;
  String updatedAt;

  NotificationInfo(
      {this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.readAt,
        this.createdAt,
        this.updatedAt});

  NotificationInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['notifiable_type'] = this.notifiableType;
    data['notifiable_id'] = this.notifiableId;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['read_at'] = this.readAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Data {
  String subject;
  String type;
  String profilePhoto;
  String url;

  Data({this.subject, this.type, this.profilePhoto, this.url});

  Data.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    type = json['type'];
    profilePhoto = json['profile_photo'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['type'] = this.type;
    data['profile_photo'] = this.profilePhoto;
    data['url'] = this.url;
    return data;
  }
}


//
// class NotificationInfo {
//   int id;
//   String senderId;
//   String receiverId;
//   String type;
//   String status;
//   String time;
//   String message;
//   bool markAsRead;
//   bool dismissed;
//   String remarks;
//
//   NotificationInfo(
//       {this.id,
//       this.senderId,
//       this.receiverId,
//       this.type,
//       this.status,
//       this.time,
//       this.message,
//       this.markAsRead,
//       this.dismissed,
//       this.remarks});
//
//   NotificationInfo.fromJson(Map<String, dynamic> json) {
//     id = json['Id'];
//     senderId = json['SenderId'];
//     receiverId = json['ReceiverId'];
//     type = json['Type'];
//     status = json['Status'];
//     time = json['Time'];
//     message = json['Message'];
//     markAsRead = json['MarkAsRead'];
//     dismissed = json['Dismissed'];
//     remarks = json['Remarks'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Id'] = this.id;
//     data['SenderId'] = this.senderId;
//     data['ReceiverId'] = this.receiverId;
//     data['Type'] = this.type;
//     data['Status'] = this.status;
//     data['Time'] = this.time;
//     data['Message'] = this.message;
//     data['MarkAsRead'] = this.markAsRead;
//     data['Dismissed'] = this.dismissed;
//     data['Remarks'] = this.remarks;
//     return data;
//   }
// }
