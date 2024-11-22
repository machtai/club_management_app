import 'dart:convert';
import 'package:club_management_app/controllers/auth_controller.dart';
import 'package:club_management_app/models/event.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventApiService {
  static const String apiUrl = 'https://ql-clb.onrender.com/api';
  final AuthController authController = Get.find<AuthController>();

  static Future<List<Event>> getAllEvents() async {
    final response = await http.get(Uri.parse('$apiUrl/get/event'));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load events");
    }
  }

  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    final token = authController.token.value;
    print(eventData);
    final response = await http.post(
      Uri.parse('$apiUrl/add/event'),
      headers: {
        'Content-Type': 'application/json',
        'Token': token,
      },
      body: json.encode(eventData),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to create event");
    }
  }

  static Future<void> deleteEvent(String eventId) async {
  final token = Get.find<AuthController>().token.value; // Lấy token từ AuthController

  final response = await http.post(
    Uri.parse('$apiUrl/delete/event'),
    headers: {
      'Content-Type': 'application/json',
      'Token': token, // Kẹp token vào headers
    },
    body: json.encode({'event_id': eventId}),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to delete event");
  }
}

 static Future<void> updateEvent(String eventId, Map<String, dynamic> updatedData) async {
  final token = Get.find<AuthController>().token.value; // Lấy token từ AuthController

  final response = await http.post(
    Uri.parse('$apiUrl/update/event'),
    headers: {
      'Content-Type': 'application/json',
      'Token': token, // Kẹp token vào headers
    },
    body: json.encode({
      '_id': eventId,
      ...updatedData,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception("Failed to update event");
  }
}


}
