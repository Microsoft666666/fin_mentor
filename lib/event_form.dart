// event_form.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _info = '';
  DateTime _date = DateTime.now();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('events').add({
        'name': _name,
        'info': _info,
        'date': _date.millisecondsSinceEpoch,
        'signUps': [],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event Created')),
      );
      _formKey.currentState!.reset();
    }
  }

  Future<void> _pickDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selected != null && selected != _date) {
      setState(() {
        _date = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Create Event', style: TextStyle(fontSize: 20)),
            TextFormField(
              decoration: InputDecoration(labelText: 'Event Name'),
              validator: (value) => value!.isEmpty ? 'Enter event name' : null,
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Event Info'),
              validator: (value) => value!.isEmpty ? 'Enter event info' : null,
              onSaved: (value) => _info = value!,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Event Date: ${_date.toLocal()}'.split(' ')[0]),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Select Date'),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
