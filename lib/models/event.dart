

import 'package:club_management_app/models/participant.dart';

class Event {
  String? id;
  String? date;
  String? description;
  String? eventName;
  String? location;
  List<Participant>? participants;
  String? status;

  Event({
    this.id,
    this.date,
    this.description,
    this.eventName,
    this.location,
    this.participants,
    this.status,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    date = json['date'];
    description = json['des'];
    eventName = json['event_name'];
    location = json['location'];
    if (json['participants'] != null) {
      participants = (json['participants'] as List)
          .map((v) => Participant.fromJson(v))
          .toList();
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'des': description,
      'event_name': eventName,
      'location': location,
      'participants': participants?.map((v) => v.toJson()).toList(),
      'status': status,
    };
  }
}
