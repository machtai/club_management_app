import 'dart:convert';
import 'package:club_management_app/controllers/auth_controller.dart';
import 'package:club_management_app/models/clb.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClubController extends GetxController {
  var clubs = <Club>[].obs;
  var isLoading = true.obs; // Loading flag
  static const url = "https://ql-clb.onrender.com/api";
  final AuthController authController = Get.find<AuthController>();

  // Fetch all clubs
  Future<void> fetchClubs() async {
    final token = authController.token.value;
    isLoading.value = true; // Start loading
    try {
      final response = await http.get(
        Uri.parse('$url/get/clb'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> clubData = json.decode(response.body);
        clubs.value = clubData.map((club) => Club.fromJson(club)).toList();
      } else {
        throw Exception('Failed to load clubs');
      }
    } catch (e) {
      print('Error fetching clubs: $e');
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Add a new club
  Future<void> addClub(Club newClub) async {
    final token = authController.token.value;
    try {
      final response = await http.post(
        Uri.parse('$url/add/clb'),
        headers: {
          'Content-Type': 'application/json',
          'Token': '$token',
        },
        body: json.encode({
          'clb_name': newClub.clbName,
          'date': "23/11/2024",
          'des': newClub.description,
        }),
      );

      if (response.statusCode == 200) {
        await fetchClubs(); // Refresh list
        Get.snackbar("Success", "Club added successfully");
      } else {
        Get.snackbar("Error", "Failed to add new club");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Error", "An error occurred while adding the club");
    }
  }

  // Update an existing club
  Future<void> updateClub(Club club) async {
    final token = authController.token.value;
    try {
      final response = await http.put(
        Uri.parse('$url/update/clb'),
        headers: {
          'Content-Type': 'application/json',
          'Token': token,
        },
        body: json.encode(club.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchClubs(); // Refresh list
      } else {
        throw Exception('Failed to update club');
      }
    } catch (e) {
      print('Error updating club: $e');
    }
  }

  // Delete a club
  Future<void> deleteClub(String clubId) async {
    final token = authController.token.value;
    try {
      final response = await http.post(
        Uri.parse('$url/delete/clb'),
        headers: {
          'Authorization': 'Bearer $token','Token': token,
        },body: json.encode({
        'clb_id': clubId,
      }),
      );

      if (response.statusCode == 200) {
        await fetchClubs(); // Refresh list
      } else {
        throw Exception('Failed to delete club');
      }
    } catch (e) {
      print('Error deleting club: $e');
    }
  }
}
