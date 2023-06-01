import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:frontend/domain/event/event.dart';

part 'event_get_event.dart';
part 'event_get_state.dart';

class EventGetBloc extends Bloc<EventGetEvent, EventGetState> {
  final EventRepository _eventRepository;

  EventGetBloc(this._eventRepository) : super(EventGetState.initial()) {
    on<GetEventById>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      print('sending request to get event with id: ${event.objectId}');

      final response = await _eventRepository.getEvent(event.objectId);

      emit(state.copyWith(
        isLoading: false,
        isError: response.isLeft(),
        event: response.fold(
          (l) => {},
          (r) => r as Map<String, dynamic>,
        ),
      ));
    });

    on<GetAllEvents>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final response = await _eventRepository.getAllEvents();

      emit(state.copyWith(
        isLoading: false,
        isError: response.isLeft(),
        events:
            response.fold((l) => [], (r) => r),
      ));
    });
  }
}