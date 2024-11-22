import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/member.dart';
import 'package:club_management_app/services/member_api_service.dart';
import 'package:flutter/material.dart';
import 'package:club_management_app/models/event.dart';
import 'package:club_management_app/screens/statistics/event_bar_chart.dart';
import 'package:club_management_app/screens/statistics/member_bar_chart.dart'; // Import the new MemberBarChart
import 'package:club_management_app/services/event_api_service.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  static String id = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

Future<Map<String, int>> getEventStatsByMonth() async {
  try {
    List<Event> events = await EventApiService.getAllEvents();
    Map<String, int> eventCountByMonth = {};

    for (var event in events) {
      if (event.date != null) {
        // Kiểm tra nếu event.date không null
        DateTime eventDate = DateTime.parse(event.date!);
        String monthKey = DateFormat('yyyy-MM').format(eventDate);
        eventCountByMonth[monthKey] = (eventCountByMonth[monthKey] ?? 0) + 1;
      }
    }

    return eventCountByMonth;
  } catch (e) {
    print("Error fetching or processing events: $e");
    return {};
  }
}

Future<Map<String, int>> getMemberStatsByMonth() async {
  try {
    List<Member> members = await MemberApiService.getMembersByClbId();
    Map<String, int> memberCountByMonth = {};

    for (var member in members) {
      if (member.join_clb_at != null && member.join_clb_at!.isNotEmpty) {
        try {
          // Try parsing the date using DateFormat
          DateTime joinDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss z').parse(member.join_clb_at!);
          String monthKey = DateFormat('yyyy-MM').format(joinDate);
          
          memberCountByMonth[monthKey] = (memberCountByMonth[monthKey] ?? 0) + 1;
          
        } catch (e) {
          print("Error parsing date for member ${member.id}: $e");
        }
      } else {
        print("No valid join_clb_at for member ${member.id}");
      }
    }

    return memberCountByMonth;
  } catch (e) {
    print("Error fetching or processing members: $e");
    return {};
  }
}


class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, int>> _eventStatsFuture;
  late Future<Map<String, int>> _memberStatsFuture;

  String selectedYear =
      DateFormat('yyyy').format(DateTime.now()); // Default to the current year

  @override
  void initState() {
    super.initState();
    _eventStatsFuture = getEventStatsByMonth();
    _memberStatsFuture = getMemberStatsByMonth();
  }

  Map<String, int> filterStatsByYear(Map<String, int> stats) {
    Map<String, int> filteredStats = {};
    stats.forEach((key, value) {
      if (key.startsWith(selectedYear)) {
        filteredStats[key] = value;
      }
    });
    return filteredStats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Event Stats
            FutureBuilder<Map<String, int>>(
              future: _eventStatsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  Map<String, int> filteredEventStats =
                      filterStatsByYear(snapshot.data!);
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: EventBarChart(eventStats: filteredEventStats),
                  );
                } else {
                  return Center(child: Text("No event data available"));
                }
              },
            ),

            // Member Stats
            FutureBuilder<Map<String, int>>(
              future: _memberStatsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  Map<String, int> filteredMemberStats =
                      filterStatsByYear(snapshot.data!);
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: MemberBarChart(memberStats: filteredMemberStats),
                  );
                } else {
                  return Center(child: Text("No member data available"));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
