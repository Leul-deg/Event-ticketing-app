import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/event/event_create/event_create_bloc.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();

  TimePicker({Key? key, required this.isEnd}) : super(key: key);

  bool isEnd;
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay selectedTime = TimeOfDay.now(); // Default time is the current time

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    ); // Display time picker dialog to the user

    if (picked != null && picked != selectedTime) {
      // If a new time is selected, update the selectedTime variable
      setState(() {
        selectedTime = picked;
        if (widget.isEnd)
          context.read<EventCreateBloc>().add(
                EventCreateEvent.endTimeChanged(selectedTime),
              );
        else{
          context.read<EventCreateBloc>().add(
                EventCreateEvent.startTimeChanged(selectedTime),
              );
        }
      });
    }

    return selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '${selectedTime.format(context)}',
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {
                _selectTime(
                    context); // Call the function to show the time picker
              },
              icon: Icon(
                Icons.access_time,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
