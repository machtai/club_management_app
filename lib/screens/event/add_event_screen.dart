import 'package:club_management_app/bottom_nav.dart';
import 'package:club_management_app/custom_app_bar.dart';
import 'package:club_management_app/models/member.dart';
import 'package:club_management_app/services/event_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  static String id = '/add_event';
  final List<Member> members;

  const AddEventScreen({
    Key? key,
    required this.members,
  }) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDateTime;
  List<Member> _selectedParticipants = [];

  // List of locations with their titles and coordinates
  final List<Map<String, dynamic>> _locations = [
    {'title': 'Cơ sở 1', 'position': LatLng(10.9530275, 106.79968)},
    {'title': 'Cơ sở 2', 'position': LatLng(10.955055, 106.7995207)},
    {'title': 'Cơ sở 3', 'position': LatLng(10.9636339, 106.7856057)},
    {'title': 'Cơ sở 4', 'position': LatLng(10.9559691, 106.7955288)},
    {'title': 'Cơ sở 5', 'position': LatLng(10.9571499, 106.7864173)},
    {'title': 'Cơ sở 6', 'position': LatLng(10.9571422, 106.7864173)},
  ];

  // Initialize EventApiService instance (using GetX or directly)
  final EventApiService eventApiService = EventApiService();

  // Date picker logic
  void _pickDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (timePicked != null) {
        setState(() {
          _selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  // Create event function
  Future<void> addEvent() async {
    if (_selectedDateTime == null || _selectedParticipants.isEmpty) {
      // Show an error message if the form is incomplete
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please complete all fields!'),
      ));
      return;
    }

    // Prepare event data to be sent to API
    final eventData = {
      'location': _locationController.text,
      'name': _nameController.text,
      'dateTime': DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!),
      'description': _descriptionController.text,
      'status': 'Sap dien ra', // Assuming it's a static status for now
      'participants': _selectedParticipants.map((member) {
        return {
          'member_id': member.id,
          'name': member.user,
          'phone': member.phone,
          'imageUrl': "member.imageUrl", // Use actual member imageUrl
        };
      }).toList(),
    };

    // Send event data to API
    try {
      await eventApiService.createEvent(eventData); // Use the instance here

      // Simulate successful event creation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Event created successfully!'),
      ));

      // Clear form after event creation
      setState(() {
        _nameController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _selectedDateTime = null;
        _selectedParticipants.clear();
      });
    } catch (e) {
      // Handle errors (optional)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create event: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomNav(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Event Name TextField with border
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Event Name",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 20),
        
              // Location DropdownButtonFormField with border
              DropdownButtonFormField<String>(
                value: _locationController.text.isEmpty
                    ? null
                    : _locationController.text,
                decoration: InputDecoration(
                  labelText: "Select Location",
                  border: OutlineInputBorder(), // Add border here
                ),
                onChanged: (String? newLocation) {
                  setState(() {
                    _locationController.text = newLocation ?? '';
                  });
                },
                items: _locations
                    .map((location) => DropdownMenuItem<String>(
                          value: location['title'],
                          child: Text(location['title']),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
        
              // Description TextField with border
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(), // Add border here
                ),
              ),
              SizedBox(height: 20),
        
              // Date and Time TextFormField with border
              GestureDetector(
                onTap: _pickDateTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _selectedDateTime == null
                          ? "Select Date & Time"
                          : DateFormat('yyyy-MM-dd HH:mm')
                              .format(_selectedDateTime!),
                      border: OutlineInputBorder(), // Add border here
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
        
              // MultiSelect Dialog Field with border
              MultiSelectDialogField(
                items: widget.members
                    .map((member) => MultiSelectItem<Member>(member, member.user))
                    .toList(),
                title: Text("Select Participants"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                buttonIcon: Icon(Icons.group_add, color: Colors.blue),
                buttonText: Text(
                  "Choose Participants",
                  style: TextStyle(color: Colors.blue[900], fontSize: 16),
                ),
                onConfirm: (selected) {
                  setState(() {
                    _selectedParticipants = List<Member>.from(selected);
                  });
                },
              ),
              SizedBox(height: 20),
        
              // Create Event Button
              ElevatedButton(
                onPressed: addEvent,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Create Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
