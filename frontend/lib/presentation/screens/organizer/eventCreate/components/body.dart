import 'package:flutter/material.dart';
import './datePicker.dart';
import './timePicker.dart';
import '../../../routes/appRouteConstants.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/application/event/event_create/event_create_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';


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

    DateTime selectedDate = DateTime.now(); // Default date is the current date

    Future<DateTime> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100)); // Set the date range for selection

      if (picked != null && picked != selectedDate) {
        // If a new date is selected, update the selectedDate variable
        setState(() {
          selectedDate = picked;
        });
      }

      return selectedDate;
    }

    return BlocConsumer<EventCreateBloc, EventCreateState>(
      listener: (context, state) {
        // show snackbar
        state.createFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    failure.map(
                      invalidEvent: () => 'Invalid event',
                      insufficientPermission: () => 'Insufficient permissions',
                      unableToUpdate: () => 'Unable to update',
                      serverError: () => 'Server error',
                      unableToDelete: () => 'Unable to delete',
                      unableToGet: () => 'Unable to get',
                      unexpectedError: () => 'Unexpected error',
                    ),
                  ),
                ),
              );

              // make the error state back to none
              print('reverting');
              context
                  .read<EventCreateBloc>()
                  .add(EventCreateEvent.revertError());
            },
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event created successfully'),
                ),
              );
              print('reverting');
              context
                  .read<EventCreateBloc>()
                  .add(EventCreateEvent.revertError());
              GoRouter.of(context).pushNamed(
                                      MyAppRouteConstants.organizerScreenRouteName);
            },
          ),
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screen.width > 600 ? screen.width * 0.15 : 18,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Your Event',
                    style: TextStyle(
                      fontSize: screen.width > 600 ? 40 : 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'roboto',
                    ),
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 13),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Event Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                          ),
                          onChanged: (val) {
                            context
                                .read<EventCreateBloc>()
                                .add(EventCreateEvent.titleChanged(val));
                          },
                        ),
                        SizedBox(height: 17),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Event Details (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                          ),
                          maxLines: 3,
                          onChanged: (val) {
                            context
                                .read<EventCreateBloc>()
                                .add(EventCreateEvent.descriptionChanged(val));
                          },
                        ),
                        SizedBox(height: 20),
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
                                TimePicker(
                                  isEnd: false,
                                ),
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
                                TimePicker(isEnd: true),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: screen.width > 600 ? 30 : 15,
                        ),
                        Divider(),
                        Center(child: DatePicker()),
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17.0),
                            ),
                          ),
                          onChanged: (val) {
                            context
                                .read<EventCreateBloc>()
                                .add(EventCreateEvent.placeChanged(val));
                          },
                        ),
                        SizedBox(height: screen.width > 600 ? 40 : 20),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                              minimumSize: MaterialStateProperty.all(
                                Size(screen.width > 600 ? 300 : 200, 50),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              context.read<EventCreateBloc>().add(
                                    EventCreateEvent.eventCreatePressed(),
                                  );
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
      },
    );
  }
}
