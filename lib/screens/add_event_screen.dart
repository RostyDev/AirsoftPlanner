import 'package:airsoftplanner/models/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../database_service.dart';

class AddEventScreen extends StatefulWidget {
  final VoidCallback onEventAdded;

  const AddEventScreen({required this.onEventAdded, super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_startDate == null
                    ? 'Select Start Date'
                    : 'Start Date: ${formatDateTime(_startDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectStartDate(context),
              ),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select Start Time'
                    : 'Start Time: ${_startTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectStartTime(context),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_endDate == null
                    ? 'Select End Date'
                    : 'End Date: ${formatDateTime(_endDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectEndDate(context),
              ),
              ListTile(
                title: Text(_endTime == null
                    ? 'Select End Time'
                    : 'End Time: ${_endTime!.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectEndTime(context),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_startDate == null || _endDate == null || _startTime == null || _endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select dates and times')),
                      );
                      return;
                    }

                    // Combine date and time for start and end
                    DateTime startDateTime = DateTime(
                      _startDate!.year,
                      _startDate!.month,
                      _startDate!.day,
                      _startTime!.hour,
                      _startTime!.minute,
                    );
                    DateTime endDateTime = DateTime(
                      _endDate!.year,
                      _endDate!.month,
                      _endDate!.day,
                      _endTime!.hour,
                      _endTime!.minute,
                    );

                    Event newEvent = Event(
                      id: 0,
                      title: _titleController.text,
                      startdate: startDateTime,
                      enddate: endDateTime,
                      location: _locationController.text,
                      beschrijving: _descriptionController.text,
                      idGebruiker: UserManager.loggedInUser!.id,
                    );

                    await DatabaseService().addEvent(newEvent);

                    widget.onEventAdded();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event added successfully')),
                    );

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
