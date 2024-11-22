import 'package:club_management_app/screens/event/map.dart';
import 'package:club_management_app/services/event_api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:club_management_app/models/event.dart';

class EventDetailScreen extends StatefulWidget {
  static String id = '/event_detail';
  final Event event;
  final int index;
  final Function deleteEvent;

  const EventDetailScreen({
    Key? key,
    required this.event,
    required this.index,
    required this.deleteEvent, required String id,
  }) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.eventName);
    _locationController = TextEditingController(text: widget.event.location);
    _descriptionController = TextEditingController(text: widget.event.description);

    // Convert string to DateTime if dateTime exists
    if (widget.event.date != null && widget.event.date!.isNotEmpty) {
      _selectedDateTime = DateTime.parse(widget.event.date!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to handle date and time selection
  Future<void> _pickDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );

      if (selectedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

void updateEvent() async {
  if (_selectedDateTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vui lòng chọn ngày và giờ cho sự kiện")),
    );
    return;
  }

  String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);

  // Dữ liệu cập nhật
  Map<String, dynamic> updatedData = {
    "event_name": _nameController.text,
    "date": formattedDateTime,
    "clb_id": "",
    "des": _descriptionController.text,
  };

  try {
    await EventApiService.updateEvent(widget.event.id!, updatedData);

    setState(() {
      widget.event.eventName = _nameController.text;
      widget.event.date = formattedDateTime;
      widget.event.description = _descriptionController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Cập nhật sự kiện thành công!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Lỗi khi cập nhật sự kiện: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Event Name"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _pickDateTime,
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: _selectedDateTime == null
                        ? "Select Date & Time"
                        : DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               ElevatedButton(
  onPressed: updateEvent,
  child: Text("Update Event"),
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 15),
  ),
),

                IconButton(
  icon: Icon(Icons.directions, color: Colors.blue),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
           eventAddress:widget.event.location!, // Truyền tên địa điểm từ sự kiện
        ),
      ),
    );
  },
)

              ],
            ),
          ],
        ),
      ),
    );
  }
}
