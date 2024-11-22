class Member {
  String id;
  String addr;
  String clbId;
  String email;
  String lop;
  String mssv;
  String phone;
  int role;
  String user;
  String? join_clb_at;
  List<String> events; // Danh sách sự kiện tham gia

  Member({
    required this.id,
    required this.addr,
    required this.clbId,
    required this.email,
    required this.lop,
    required this.mssv,
    required this.phone,
    required this.role,
    required this.user,
    this.join_clb_at,
    this.events =
        const [], // Đặt mặc định là danh sách rỗng nếu không có 'events'
  });

  // Chuyển từ JSON sang đối tượng Member
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'] ?? '', // Nếu _id là null, sử dụng chuỗi rỗng
      addr: json['addr'] ?? '', // Nếu addr là null, sử dụng chuỗi rỗng
      clbId: json['clb_id'] ?? '', // Nếu clb_id là null, sử dụng chuỗi rỗng
      email: json['email'] ?? '', // Nếu email là null, sử dụng chuỗi rỗng
      lop: json['lop'] ?? '', // Nếu lop là null, sử dụng chuỗi rỗng
      mssv: json['mssv'] ?? '', // Nếu mssv là null, sử dụng chuỗi rỗng
      phone: json['phone'] ?? '', // Nếu phone là null, sử dụng chuỗi rỗng
      role:
          json['role'] ?? 0, // Nếu role là null, sử dụng giá trị mặc định là 0
      user: json['user'] ?? '', // Nếu user là null, sử dụng chuỗi rỗng
      events: json['event_id'] != null
          ? List<String>.from(json['event_id'])
          : [], // Nếu events là null, sử dụng danh sách rỗng
      join_clb_at: json['join_clb_at'] ?? '',
    );
  }

  // Chuyển từ đối tượng Member sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'addr': addr,
      'clb_id': clbId,
      'email': email,
      'lop': lop,
      'mssv': mssv,
      'phone': phone,
      'role': role,
      'user': user,
      'join_clb_at': join_clb_at,
      'events': events,
    };
  }
}
