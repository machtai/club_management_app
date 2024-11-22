class User {
  final String user;
  final String email;
  final String phone;
  final String addr;
  final int role;
  final String? clbId;
  final String? msnv;
  final DateTime? loginTime;
  final int? exp;

  User({
    required this.user,
    required this.email,
    required this.phone,
    required this.addr,
    required this.role,
    this.clbId,
    this.msnv,
    this.loginTime,
    this.exp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user: json['user'],
      email: json['email'],
      phone: json['phone'],
      addr: json['addr'],
      role: json['role'],
      clbId: json['clb_id'],
      msnv: json['msnv'],
      loginTime: json['login_time'] != null
          ? DateTime.parse(json['login_time'])
          : null,
      exp: json['exp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'email': email,
      'phone': phone,
      'addr': addr,
      'role': role,
      'clb_id': clbId,
      'msnv': msnv,
      'login_time': loginTime?.toIso8601String(),
      'exp': exp,
    };
  }
}
