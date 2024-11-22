import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/event.dart';
import 'package:club_management_app/models/member.dart';
import 'package:club_management_app/services/event_api_service.dart';
import 'package:club_management_app/services/member_api_service.dart';
import 'package:flutter/material.dart';
import 'add_event_screen.dart';
import 'event_detail_screen.dart';

class EventManagementScreen extends StatefulWidget {
  static String id = '/events';

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  List<Event> events = [];
  List<Member> members = [];
  List<Event> filteredEvents = [];
  bool isLoading = true;
  bool isAscending = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEvents();
    fetchMembers();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await EventApiService.getAllEvents();
      if (response.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      setState(() {
        events = response;
        filteredEvents = List.from(events); // Make a copy for search filtering
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching events: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching events: $e")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMembers() async {
    try {
      members = await MemberApiService.getMembersByClbId();
      setState(() {}); // Refresh UI after members are fetched
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching members: $e")),
      );
    }
  }

 // Delete an event
void deleteEvent(String eventId, int index) async {
  try {
    await EventApiService.deleteEvent(eventId);
    setState(() {
      filteredEvents.removeAt(index); // Remove event from displayed list
      events.removeAt(index); // Remove event from original list
    });
    // Show success Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Event deleted successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error deleting event: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  // Search function for filtering events
  void _searchEvent(String query) {
    setState(() {
      filteredEvents = query.isEmpty
          ? List.from(events)
          : events
              .where((event) =>
                  event.eventName!.toLowerCase().contains(query.toLowerCase()) ||
                  event.location!.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  // Sort events alphabetically
  void _sortEvents() {
    setState(() {
      filteredEvents.sort((a, b) =>
          isAscending ? a.eventName!.compareTo(b.eventName!) : b.eventName!.compareTo(a.eventName!));
      isAscending = !isAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search events...',
                            prefixIcon: Icon(Icons.search, color: Colors.blue),
                            filled: true,
                            fillColor: Colors.blue.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onChanged: _searchEvent,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          isAscending ? Icons.sort_by_alpha : Icons.sort,
                          color: Colors.blue,
                        ),
                        onPressed: _sortEvents,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final newEvent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEventScreen(members: members),
                            ),
                          );
                          if (newEvent != null && newEvent is Event) {
                            setState(() {
                              events.add(newEvent);
                              filteredEvents.add(newEvent);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: Colors.blue,
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              event.eventName ?? 'Unnamed Event',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "${event.date ?? 'No date'} - ${event.location ?? 'No location'}",
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailScreen(
                                          event: event,
                                          id: event.id!,
                                          index: index,
                                          deleteEvent: deleteEvent,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteEvent(event.id!, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
