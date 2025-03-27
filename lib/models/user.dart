class AppUserData {

  late String username;
  late String email;
  late String password;
  late String phone;

  AppUserData({
    required this.email,
    required this.username,
    required this.phone,
    required this.password
  });

  AppUserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['email'] =  email;
    data['username'] = username ;
    data['phone'] = phone;
    data['password'] = password ;
    return data;
  }


}
