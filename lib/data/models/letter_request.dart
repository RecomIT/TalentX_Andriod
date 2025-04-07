class LetterRequest {
  String employeeDivision;
  String employeeDepartment;
  String dateOfJoin;
  String employeeRole;
  String lineManager;
  List<RequisitionFor> requisitionFor;
  List<LetterReason> salaryCertificate;
  List<LetterReason> introductoryLetter;
  List<LetterReason> experienceLetter;
  List<LetterReason> invitationLetter;
  List<Embassy> embassy;

  LetterRequest(
      {this.employeeDivision,
        this.employeeDepartment,
        this.dateOfJoin,
        this.employeeRole,
        this.lineManager,
        this.requisitionFor,
        this.salaryCertificate,
        this.introductoryLetter,
        this.experienceLetter,
        this.invitationLetter,
      this.embassy});

  LetterRequest.fromJson(Map<String, dynamic> json) {
    employeeDivision = json['employee_division']?? 'N/A';
    employeeDepartment = json['employee_department']?? 'N/A';
    dateOfJoin = json['date_of_join']?? 'N/A';
    employeeRole = json['employee_role']?? 'N/A';
    lineManager = json['line_manager']?? 'N/A';
    if (json['requisition_for'] != null) {
      requisitionFor = <RequisitionFor>[];
      json['requisition_for'].forEach((v) {
        requisitionFor.add(new RequisitionFor.fromJson(v));
      });
    }
    if (json['salary_certificate'] != null) {
      salaryCertificate = <LetterReason>[];
      json['salary_certificate'].forEach((v) {
        salaryCertificate.add(new LetterReason.fromJson(v));
      });
    }
    if (json['introductory_letter'] != null) {
      introductoryLetter = <LetterReason>[];
      json['introductory_letter'].forEach((v) {
        introductoryLetter.add(new LetterReason.fromJson(v));
      });
    }
    if (json['experience_letter'] != null) {
      experienceLetter = <LetterReason>[];
      json['experience_letter'].forEach((v) {
        experienceLetter.add(new LetterReason.fromJson(v));
      });
    }
    if (json['invitation_letter'] != null) {
      invitationLetter = <LetterReason>[];
      json['invitation_letter'].forEach((v) {
        invitationLetter.add(new LetterReason.fromJson(v));
      });
    }

    if (json['embassy'] != null) {
      embassy = <Embassy>[];
      json['embassy'].forEach((v) {
        embassy.add(new Embassy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_division'] = this.employeeDivision;
    data['employee_department'] = this.employeeDepartment;
    data['date_of_join'] = this.dateOfJoin;
    data['employee_role'] = this.employeeRole;
    data['line_manager'] = this.lineManager;
    if (this.requisitionFor != null) {
      data['requisition_for'] =
          this.requisitionFor.map((v) => v.toJson()).toList();
    }
    if (this.salaryCertificate != null) {
      data['salary_certificate'] =
          this.salaryCertificate.map((v) => v.toJson()).toList();
    }
    if (this.introductoryLetter != null) {
      data['introductory_letter'] =
          this.introductoryLetter.map((v) => v.toJson()).toList();
    }
    if (this.experienceLetter != null) {
      data['experience_letter'] =
          this.experienceLetter.map((v) => v.toJson()).toList();
    }
    if (this.invitationLetter != null) {
      data['invitation_letter'] =
          this.invitationLetter.map((v) => v.toJson()).toList();
    }
    if (this.embassy != null) {
      data['embassy'] = this.embassy.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequisitionFor {
  String key;
  String value;

  RequisitionFor({this.key, this.value});

  RequisitionFor.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? 'N/A';
    value = json['value'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class LetterReason {
  String key;
  String value;

  LetterReason({this.key, this.value});

  LetterReason.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? json['Key'] ?? 'N/A';
    value = json['value']?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class Embassy {
  String embassyName;
  String address;

  Embassy({this.embassyName, this.address});

  Embassy.fromJson(Map<String, dynamic> json) {
    embassyName = json['embassy_name'] ?? '';
    address = json['address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['embassy_name'] = this.embassyName;
    data['address'] = this.address;
    return data;
  }

}

// class SalaryCertificate {
//   String key;
//   String value;
//
//   SalaryCertificate({this.key, this.value});
//
//   SalaryCertificate.fromJson(Map<String, dynamic> json) {
//     key = json['key']?? 'N/A';
//     value = json['value']?? 'N/A';
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     return data;
//   }
// }
// class IntroductoryLetter {
//   String key;
//   String value;
//
//   IntroductoryLetter({this.key, this.value});
//
//   IntroductoryLetter.fromJson(Map<String, dynamic> json) {
//     key = json['key']?? 'N/A';
//     value = json['value']?? 'N/A';
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     return data;
//   }
// }
// class ExperienceLetter {
//   String key;
//   String value;
//
//   ExperienceLetter({this.key, this.value});
//
//   ExperienceLetter.fromJson(Map<String, dynamic> json) {
//     key = json['key']?? 'N/A';
//     value = json['value']?? 'N/A';
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     return data;
//   }
// }
// class InvitationLetter {
//   String key;
//   String value;
//
//   InvitationLetter({this.key, this.value});
//
//   InvitationLetter.fromJson(Map<String, dynamic> json) {
//     key = json['key']?? 'N/A';
//     value = json['value']?? 'N/A';
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['key'] = this.key;
//     data['value'] = this.value;
//     return data;
//   }
// }

