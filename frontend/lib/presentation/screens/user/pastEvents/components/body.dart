import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/application/event/event_get/event_get_bloc.dart';
import 'package:frontend/domain/event/event.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/appRouteConstants.dart';
import './eventCards.dart';

class Body extends StatefulWidget {
  const Body({Key? key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<EventCards> eventCards = List.generate(
    13,
    (index) => EventCards(
      title: 'Rophnan Concert NEW',
    ),
  );

  @override
  void initState() {
    print('in the freaking padskfhkjakjsdf hjahdfkjaj sfkjsadfkjfh');
    super.initState();
    print('hererauidhflajkhdfuih');
    context.read<EventGetBloc>().add(EventGetEvent.getAllEvents());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventGetBloc, EventGetState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List<EventModel> eventCards = state.events as List<EventModel>;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Past Events',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            elevation: 0,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                itemCount: eventCards.length,
                itemBuilder: (context, index) {
                  final eventCard = eventCards[index];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(MyAppRouteConstants.eventDetailRouteName);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventCard.title,
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Location: New York City',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
