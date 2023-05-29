import 'package:flutter/material.dart';
import './datePicker.dart';
import './timePicker.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String eventTitle = '';
  String eventDate = '';
  String eventTime = '';
  String eventLocation = '';
  String eventDetails = '';
  String eventOrganizers = '';
  String eventImage = '';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screen.width > 600 ? screen.width * 0.15 : 18,
            vertical: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Post Your Event',
                style: TextStyle(
                  fontSize: screen.width > 600 ? 50 : 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto',
                ),
              ),
              SizedBox(height: 25),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What is your event about?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width > 600 ? 30 : 20,
                        color: Colors.indigo[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Event Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          eventTitle = val;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Event Details (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (val) {
                        setState(() {
                          eventDetails = val;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'When is it happening?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width > 600 ? 30 : 20,
                        color: Colors.indigo[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Start Time',
                              style: TextStyle(
                                fontSize: screen.width > 600 ? 24 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: screen.width > 600 ? 20 : 7,
                            ),
                            TimePicker(),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'End Time',
                              style: TextStyle(
                                fontSize: screen.width > 600 ? 24 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: screen.width > 600 ? 20 : 7,
                            ),
                            TimePicker(),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: screen.width > 600 ? 30 : 15,
                    ),
                    Divider(),
                    DatePicker(),
                    SizedBox(height: 20),
                    Text(
                      'Where will it take place?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width > 600 ? 30 : 20,
                        color: Colors.indigo[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          eventLocation = val;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Do you have a photo to share?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screen.width > 600 ? 30 : 20,
                        color: Colors.indigo[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Link',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) {
                        setState(() {
                          eventDetails = val;
                        });
                      },
                    ),
                    SizedBox(height: screen.width > 600 ? 40 : 20),
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple.shade200,
                          ),
                          minimumSize: MaterialStateProperty.all(
                            Size(screen.width > 600 ? 300 : 200, 50),
                          ),
                        ),
                        onPressed: () {
                          // Submit form data to database
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
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

