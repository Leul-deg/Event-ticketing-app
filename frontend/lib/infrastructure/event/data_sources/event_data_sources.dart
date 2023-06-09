import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/domain/event/event.dart';

import '../../../data/local/local_database/local_storage.dart';

class EventDataSource implements EventRepository {
  final client = http.Client();

  final API_URL = "http://10.0.2.2:3000";
  final LocalDatabase localStorage = LocalDatabase.instance;

  EventDataSource();

  @override
  Future<Either<EventFailure, Object>> createEvent(
      EventCreateModel eventCreateModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');
    print('got the event');
    print(eventCreateModel.toJson());

    final response = await client.post(Uri.parse('$API_URL/event'),
        body: eventCreateModel.toJson(),
        headers: {'Authorization': 'Bearer $jwtToken'});

    final Map<String, Object?> responseBody = jsonDecode(response.body);
    final dynamic id = responseBody.remove('_id');
    responseBody.remove('__v');
    responseBody.addAll({'eventId': id});
    final String encodedBody = jsonEncode(responseBody);
    print(encodedBody);
    await localStorage.insert('events', responseBody);
    // await localStorage.insert('events', json.decode(response.body));
    print("created an event successfully to the motherfucking database");

    print('got response');
    print(response.statusCode);

    if (response.statusCode == 201) {
      return Right(json.decode(response.body));
    } else if (response.statusCode == 400) {
      return Left(EventFailure.invalidEvent());
    } else {
      return Left(EventFailure.serverError());
    }
  }

  @override
  Future<Either<EventFailure, Object>> updateEvent(
      String id, EventUpdateModel eventUpdateModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');
    print('in the data source');
    final data = eventUpdateModel.toJson();
    data.removeWhere((key, value) => value == null);

    final response = await client.put(Uri.parse('$API_URL/event/update/$id'),
        body: data, headers: {'Authorization': 'Bearer $jwtToken'});

    print('got response');
    print(response.statusCode);

    if (response.statusCode == 200) {
      return Right(json.decode(response.body));
    } else if (response.statusCode == 400) {
      return Left(EventFailure.invalidEvent());
    } else {
      return Left(EventFailure.serverError());
    }
  }

  @override
  Future<Either<EventFailure, Object>> deleteEvent(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');
    final response = await client.delete(Uri.parse('$API_URL/event/delete/$id'),
        headers: {'Authorization': 'Bearer $jwtToken'});

    if (response.statusCode == 200) {
      return const Right(Object);
    } else if (response.statusCode == 400) {
      return Left(EventFailure.invalidEvent());
    } else {
      return Left(EventFailure.serverError());
    }
  }

  @override
  Future<Either<EventFailure, List<dynamic>>> getAllEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    var es = await localStorage.getter('events');
    try {
      final response = await client.get(Uri.parse('$API_URL/event'), headers: {
        'Authorization': 'Bearer $jwtToken'
      }).timeout(const Duration(seconds: 5));

      print('here is the status code');

      print(response.statusCode);

      if (response.statusCode != 200) {
        print("I got in the status code and everything ");

        if (es.isNotEmpty) {
          print('got the events from the database');
          return Right(es);
        }

        return Left(EventFailure.unableToGet());
      } else {
        print('got the events');

        final allEvents = json.decode(response.body);
        var c = await localStorage.insertEvents(allEvents);
        print('here is the c');

        return Right(json.decode(response.body));
      }
    } catch (e) {
      print('im in nnnn');
      if (es.isNotEmpty) {
        print('got the events from the database');
        return Right(es);
      }
      return Left(EventFailure.unableToGet());
    }
  }

  @override
  Future<Either<EventFailure, Object>> getEvent(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');
    // Implementation of the getEvent method goes here
    try {
      // Get the event data from the API
      final eventData = await client.get(Uri.parse('$API_URL/event/$id'),
          headers: {'Authorization': 'Bearer $jwtToken'});

      print(eventData.statusCode);

      // If the response is not 200, throw an error
      if (eventData.statusCode != 200) {
        return Left(EventFailure.unableToGet());
      }

      // Convert the response body to a Map object
      final eventDataMap = json.decode(eventData.body) as Map<String, dynamic>;

      // Return the EventModel object wrapped in a Right Either object
      return Right(eventDataMap);
    } catch (e) {
      // If there is an error getting the event data from the API, return a Left Either object
      // with an EventFailure object containing an error message
      return Left(EventFailure.unableToGet());
    }
  }

  // get events by organizerId

  @override
  Future<Either<EventFailure, List<dynamic>>> getEventsByOrganizerId(
      String organizerId) async {
    // var es = await localStorage.getter('events');
    // if (es.isEmpty){
    //   print('got the events from the database');
    //   await getAllEvents();

    // }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    print(jwtToken);
    print('the toekn kl;akdjf;alkdj;fkadj;fk');

    // Implementation of the getEvent method goes here
    try {
      print('here is the data');
      print(organizerId);
      // Get the event data from the API
      final eventData = await client
          .get(Uri.parse('$API_URL/event/organizer/$organizerId'), headers: {
        'Authorization': 'Bearer $jwtToken'
      }).timeout(const Duration(seconds: 5));

      print(eventData.statusCode);
      print(eventData.body);

      // If the response is not 200, throw an error
      if (eventData.statusCode != 200) {
        var events = await localStorage.getEventsByOrganizerId(organizerId);
      if (events.isNotEmpty) {
        return Right(events);
      }

        return Left(EventFailure.unableToGet());
      }

      print('here is the actual data');

      print(eventData.body);

      // Convert the response body to a Map object
      final eventDataMap = json.decode(eventData.body) as List<dynamic>;

      // Return the EventModel object wrapped in a Right Either object
      return Right(eventDataMap);
    } catch (e) {
      // If there is an error getting the event data from the API, return a Left Either object
      // with an EventFailure object containing an error message
      var events = await localStorage.getEventsByOrganizerId(organizerId);
      if (events.isNotEmpty) {
        return Right(events);
      }

      return Left(EventFailure.unableToGet());
    }
  }
}
