class User {
  String accessToken;
  String tokenType;
  String userID;
  String name;
  String username;
  String email;
  String role;
  bool supervisor;
  String supervisor_id;
  String supervisor_name;
  String employee_id;
  String business_unit_id;
  String status;
  String message;
  DateTime loginTime;
  DateTime expireTime;

  User(
      {this.accessToken,
      this.tokenType,
      this.userID,
      this.employee_id,
      this.name,
      this.username,
      this.email,
      this.role,
      this.supervisor,
      this.supervisor_id,
        this.supervisor_name,
        this.business_unit_id,
      this.status,
      this.message,this.loginTime,this.expireTime});

   User.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    name = json['name'];
    username = json['username'];
    status = json['status'];

    //------Not required for Shop Up--------
    userID = "1";//json['userID'];
    email = json['username'];//json['email'];
    role = json['type'].toString().toLowerCase();
    supervisor= json['isSupervisor'];
    supervisor_id=json['supervisor_id'].toString() =='null' ? '' : json['supervisor_id'].toString().trim();
    supervisor_name=json['supervisor_name'].toString() =='null' ? '' : json['supervisor_name'].toString().trim();

    business_unit_id=json['business_unit_id'].toString() =='null' ? '' : json['business_unit_id'].toString().trim();
    employee_id = json['employee_id'].toString() =='null' ? '' : json['employee_id'].toString().trim();

    //print('IS SUPERVISOR ' + supervisor.toString());

    //role = "admin";
    message = "N/A";//json['message'];
    loginTime = DateTime.now();
    expireTime= DateTime.now().add(Duration(hours: 24)); //hours: 24
  }

  bool get isAdmin => role != 'user';
  bool get isSupervisor => supervisor;
  //bool get isAdmin => false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['name'] = this.name;
    data['username'] = this.username;
    data['status'] = this.status;
    data['type'] = this.role;
    data['isSupervisor'] = this.supervisor;
    data['supervisor_id'] = this.supervisor_id;
    data['supervisor_name'] = this.supervisor_name;
    data['business_unit_id'] = this.business_unit_id;
    data['employee_id'] = this.employee_id;
    data['loginTime'] = this.loginTime.toIso8601String();
    data['expireTime'] = this.expireTime.toIso8601String();
    //------Not required for Shop Up--------
    // data['userID'] = this.userID;
    // data['email'] = this.email;
    // data['role'] = this.role;
    // data['message'] = this.message;
    return data;
  }
}
