import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_mentor/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _info = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now(); // Added for time
  int _pageFrom = 0;
  int _pageTo = 0;
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Combine the date and time into a single DateTime object
      final eventDateTime = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      await FirebaseFirestore.instance.collection('events').add({
        'name': _name,
        'info': _info,
        'date': eventDateTime.millisecondsSinceEpoch,
        'pageFrom': _pageFrom,
        'pageTo': _pageTo,
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

  Future<void> _pickTime() async {
    TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (selected != null && selected != _time) {
      setState(() {
        _time = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_date.toLocal());
    return Scaffold(
      appBar: AppBar(
          title: Text('Create Event',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic))),
      body: Container(
        height: double.infinity,

        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Event Name',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: EventApp.surfaceColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        TextFormField(

                          style: TextStyle(color: EventApp.surfaceColor),
                          decoration: InputDecoration(
                              labelText: 'Event Name',
                              labelStyle: TextStyle(color: EventApp.surfaceColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor), // Border color when not focused
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor, width: 2), // Border color when focused
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor), // General border color
                            ),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? 'Enter event name' : null,
                          onSaved: (value) => _name = value!,
                        ),
                        SizedBox(height: 10),
                        Text('Event Info',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: EventApp.surfaceColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                        TextFormField(
                          maxLines: 4,
                          decoration: InputDecoration(
                              labelText: 'Event Info',
                              labelStyle: TextStyle(color: EventApp.surfaceColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor), // Border color when not focused
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor, width: 2), // Border color when focused
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: EventApp.surfaceColor), // General border color
                            ),),
                          validator: (value) =>
                          value!.isEmpty ? 'Enter event info' : null,
                          onSaved: (value) => _info = value!,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            RichText(text: TextSpan(
                              text: "Referenced Pages: ",
                              style: TextStyle(
                                color: EventApp.surfaceColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            )),
                            Expanded(
                                child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
                              ],
                              keyboardType: TextInputType.number,

                              decoration: InputDecoration(
                                labelText: "From",
                                labelStyle: TextStyle(color: EventApp.surfaceColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: EventApp.surfaceColor), // Border color when not focused
                                ),
                              ),
                              onSaved: (value) => _pageFrom = int.parse(value!),
                            )),
                            SizedBox(width: 10),
                            Text("To",
                              style: TextStyle(
                                color: EventApp.surfaceColor,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*')),
                                  ],
                                  keyboardType: TextInputType.number,

                                  decoration: InputDecoration(
                                    labelText: "Page",
                                    labelStyle: TextStyle(color: EventApp.surfaceColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: EventApp.surfaceColor), // Border color when not focused
                                    ),
                                  ),
                                  onSaved: (value) => _pageTo = int.parse(value!),
                                )),


                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: EventApp.surfaceColor,
                                  fontSize: 20,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Event Date: \n',
                                    style: TextStyle(
                                      color: EventApp.surfaceColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${_date.toLocal().toString().substring(0, 10)}',
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                EventApp.surfaceColor,
                              ),
                              onPressed: _pickDate,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today),
                                  SizedBox(width: 4),
                                  Text('Select Date'),
                                ],
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: EventApp.surfaceColor,
                                  fontSize: 20,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Event Time: \n',
                                    style: TextStyle(
                                      color: EventApp.surfaceColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  TextSpan(
                                    text: '${_time.format(context)}', // Display selected time
                                  ),
                                ],
                              ),
                            ),


                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Color.fromRGBO(247, 253, 247, 0.85),
                              ),
                              onPressed: _pickTime,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 4),
                                  Text('Select Time'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(247, 253, 247, 0.85),
                ),
                onPressed: _submit,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    Text('Create Event', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
