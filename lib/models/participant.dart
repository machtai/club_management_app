
class Participant {
  String? imageUrl;
  String? memberId;
  String? name;
  String? phone;

  Participant({this.imageUrl, this.memberId, this.name, this.phone});

  Participant.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    memberId = json['member_id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'member_id': memberId,
      'name': name,
      'phone': phone,
    };
  }
}

